//
//  Donation.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Donation: Identifiable, Codable {
    @DocumentID var id: String?
    let projectId: String
    let projectTitle: String
    let donorId: String
    let donorName: String
    let amount: Double
    let comment: String?
    let verified: Bool
    let createdAt: Date
    let updatedAt: Date
    
    var project: Project?
}

extension Donation {
    static var sample: Donation = {
        var sample = Donation(projectId: "projectId", projectTitle: "project 1", donorId: "donorId", donorName: "Bill Gates", amount: 200000, comment: nil, verified: true, createdAt: .now, updatedAt: .now)
        sample.project = Project.sample
        return sample
    }()
}
