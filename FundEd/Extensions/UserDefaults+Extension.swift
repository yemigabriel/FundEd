//
//  UserDefaults+Extension.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import Foundation

extension UserDefaults {
    func saveUser(user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            let userJson = String(data: userData, encoding: .utf8)
            self.set(userJson, forKey: "CURRENT_USER")
        }
    }
    
    func getUser() -> User? {
        var user: User?
        let userJson = self.string(forKey: "CURRENT_USER")
        if let userData = userJson?.data(using: .utf8) {
            if let _user = try? JSONDecoder().decode(User.self, from: userData) {
                user = _user
            }
        }
        return user
    }
}
