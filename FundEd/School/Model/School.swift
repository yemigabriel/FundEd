//
//  School.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
//import FirebaseFirestoreSwift

struct School: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    let localGovernment: String
    let type: String
    let ownership: String
    
    static let allSchools: [School] = Bundle.main.decode("schools_lagos.json")
    static let emptySchool: School = School(id: 0, name: "Choose a school", localGovernment: "", type: "", ownership: "")
}

enum SchoolType: String {
    case nursery_primary = "nursery_primary"
    case secondary = "secondary"
}

enum SchoolOwnership: String {
    case state_owned = "state_owned"
    case privately_owned = "privately_owned"
}
