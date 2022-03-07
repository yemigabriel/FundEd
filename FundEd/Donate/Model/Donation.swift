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
    let donorId: String
    let donorName: String
    let amount: Double
    let comment: String?
    let verified: Bool
    let createdAt: Date
    let updatedAt: Date
}
