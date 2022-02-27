//
//  School.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
//import FirebaseFirestoreSwift

struct School: Identifiable, Codable {
    var id: Int
    let name: String
    let localGovernment: String
    let type: String
    let ownership: String
}

enum SchoolType: String {
    case nursery_primary = "nursery_primary"
    case secondary = "secondary"
}

enum SchoolOwnership: String {
    case state_owned = "state_owned"
    case privately_owned = "privately_owned"
}
