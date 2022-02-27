//
//  ProjectMaterial.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ProjectMaterial: Identifiable, Codable {
    @DocumentID var id: String?
    let item: String
    let quantity: Int
    let amount: Double
    let projectId: String
    let createdAt: Date
    let updatedAt: Date
    
    var totalAmount: Double {
        amount * Double(quantity)
    }
}
