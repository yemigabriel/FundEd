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
    var item: String
    var quantity: Int
    var cost: Double
    var projectId: String
    let createdAt: Date
    let updatedAt: Date
    
    var totalAmount: Double {
        cost * Double(quantity)
    }
    
}

extension ProjectMaterial {
    
    static var empty = ProjectMaterial(item: "", quantity: 1, cost: 0.0, projectId: "")
    
    init(item: String, quantity: Int, cost: Double, projectId: String) {
        self.id = UUID().uuidString
        self.item = item
        self.quantity = quantity
        self.cost = cost
        self.projectId = projectId
        self.createdAt = Date.now
        self.updatedAt = Date.now
    }
}
