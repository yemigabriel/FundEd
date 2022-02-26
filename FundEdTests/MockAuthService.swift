//
//  MockAuthService.swift
//  FundEdTests
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
@testable import FundEd

final class MockAuthService: AuthServiceProtocol {
    @Published var user: User?
    var userPublisher: Published<User?>.Publisher{ $user }
    static let shared = MockAuthService()
    
    private init() {
    }
    
    func signIn(email: String, password: String) {
        self.user = User(id: "id", name: "name", email: email)
    }
    
    func signUp(_ user: User) {
        self.user = user
    }
    
    func getCurrentUser() {
        
    }
    
    func signOut() {
        
    }
    
    
}
