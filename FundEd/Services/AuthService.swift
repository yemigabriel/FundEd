//
//  AuthService.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/20/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AuthServiceProtocol {
    var userPublisher: Published<User?>.Publisher {get}
    func signIn(email: String, password: String)
    func signUp(_ user: User)
    func getCurrentUser()
    func signOut()
}

class AuthService: AuthServiceProtocol, UserProfileServiceProtocol, ObservableObject {
    
    @Published var user: User?
    var userPublisher: Published<User?>.Publisher {$user}
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let store = Firestore.firestore()
    let userProfileCollection = "user_profiles"
    
    private init() {
        getCurrentUser()
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { data, error in
            guard let data = data, error == nil else {
                //MARK: proper error handling
                print("Error: \(error!.localizedDescription)")
                return
            }
            self.getProfile(for: data.user.uid)
        }
    }
    
    func signUp(_ user: User) {
        auth.createUser(withEmail: user.email, password: user.password!) { data, error in
            guard let data = data, error == nil else {
                //MARK: proper error handling
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            let user = User(id: data.user.uid, name: user.name, email: user.email, role: user.role)
            self.createProfile(for: user)
        }
    }
    
    func createProfile(for user: User) {
        do {
            _ = try store.collection(userProfileCollection).addDocument(from: user)
            self.user = user
        } catch {
            print("Error creating profile: \(error.localizedDescription)")
            return
        }
    }
    
    func getProfile(for userId: String) {
        store.collection(userProfileCollection).whereField("uid", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            self.user = snapshot?.documents.compactMap({ queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: User.self)
            })[0]
            
            print(self.user?.email)
        }
    }
    
    func getCurrentUser() {
        if let currentUser = auth.currentUser {
            print(currentUser.uid)
            getProfile(for: currentUser.uid)
            return
        }
        print("Not currently signed in")
    }
    
    func signOut() {
        try? auth.signOut()
    }
    
    
    func getCustomClaims() {
        auth.currentUser?.getIDTokenResult(completion: { result, error in
        })
    }
    
}


