//
//  User.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/20/22.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let email: String
    let password: String?
    let role: String?
    let createdAt: Date
    let updatedAt: Date
    let verified: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case name, role, email, password, createdAt, updatedAt, verified
    }
}

extension User {
    init(id: String,
         name: String,
         email: String,
         password: String? = nil,
         role: String? = UserRole.donor.rawValue) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.createdAt = Date()
        self.updatedAt = Date()
        self.verified = false
    }
}

extension User {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        verified = try container.decode(Bool.self, forKey: .verified)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(role, forKey: .role)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(verified, forKey: .verified)
    }
}

extension User {
    static func ==(lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id && lhs.email == rhs.email
    }
    
    static func ==(lhs: Binding<Optional<User>>, rhs: User) -> Bool  {
        lhs.wrappedValue != nil && lhs.wrappedValue == rhs
    }

}
