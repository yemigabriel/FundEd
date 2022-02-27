//
//  AuthService.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/20/22.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AuthServiceProtocol {
    var userPublisher: PassthroughSubject<User, FirebaseError> {get}
    func signIn(email: String, password: String)
    func signUp(_ user: User)
    func getCurrentUser()
    func signOut()
}

class AuthService: ObservableObject, AuthServiceProtocol {
    var userPublisher = PassthroughSubject<User, FirebaseError>()
    
    static let shared = AuthService()
    private var userService: UserProfileServiceProtocol
    private let auth = Auth.auth()
    private var cancellables = Set<AnyCancellable>()
    
    private init(userService: UserProfileServiceProtocol = UserProfileService.shared) {
        self.userService = userService
        
        userService.userPublisher.sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.userPublisher.send(completion: .failure(.firebaseAuth(error: error.localizedDescription)))
            case .finished:
                print("completion: \(completion)")
            }
        } receiveValue: { [weak self] user in
            self?.userPublisher.send(user)
        }
        .store(in: &cancellables)

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
        userService.createProfile(for: user)
    }
    
    func getProfile(for userId: String) {
        userService.getProfile(for: userId)
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


