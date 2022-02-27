//
//  MockAuthService.swift
//  FundEdTests
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Combine
@testable import FundEd

final class MockAuthService: AuthServiceProtocol {
    var userPublisher = PassthroughSubject<User, FirebaseError>()
    
//    @Published var user: User?
    static let shared = MockAuthService()
    
    private init() {
    }
    
    func signIn(email: String, password: String) {
        let user = User(id: "id", name: "name", email: email)
        userPublisher.send(user)
    }
    
    func signUp(_ user: User) {
//        self.user = user
        userPublisher.send(user)
    }
    
    func getCurrentUser() {
        
    }
    
    func signOut() {
        
    }
    
    
}
