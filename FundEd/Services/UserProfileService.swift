//
//  UserProfileViewModel.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/24/22.
//

import Foundation

protocol UserProfileServiceProtocol {
    var userPublisher: Published<User?>.Publisher {get}
    func getProfile(for userId: String)
    func createProfile(for user: User)
}

class UserProfileService: UserProfileServiceProtocol, ObservableObject{
    
    @Published var user: User?
    var userPublisher: Published<User?>.Publisher{$user}
    
    init() {
    }
    
    func getProfile(for userId: String) {
        
    }
    
    func createProfile(for user: User) {
        
    }
    
    
}
