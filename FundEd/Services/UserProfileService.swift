//
//  UserProfileViewModel.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/24/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserProfileServiceProtocol {
    var userPublisher: PassthroughSubject<User, FirebaseError> {get}
    
    func getProfile(for userId: String)
    func createProfile(for user: User)
}

class UserProfileService: UserProfileServiceProtocol, ObservableObject{
    static let shared = UserProfileService()
    var userPublisher = PassthroughSubject<User, FirebaseError>()
    
    private let store = Firestore.firestore()
    private let userProfileCollection = "user_profiles"
    
    private init() {
    }
    
    func getProfile(for userId: String) {
        store.collection(userProfileCollection).whereField("uid", isEqualTo: userId).getDocuments { [weak self] snapshot, error in
            if let error = error {
                self?.userPublisher.send(completion: .failure(.firebaseAuth(error: error.localizedDescription)))
                return
            }
            if let user = snapshot?.documents.compactMap({ queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: User.self)
            }).first {
                self?.userPublisher.send(user)
                //save to user defaults
                UserDefaults.standard.saveUser(user: user)
            } else {
                self?.userPublisher.send(completion: .failure(.userNotExists(error: "User does not exist")))
            }
        }
    }
    
    func createProfile(for user: User) {
        do {
            _ = try store.collection(userProfileCollection).addDocument(from: user)
            userPublisher.send(user)
            //save to user defaults
            UserDefaults.standard.saveUser(user: user)
        } catch {
            userPublisher.send(completion: .failure(.firebaseAuth(error: error.localizedDescription)))
            return
        }
    }
    
    
}
