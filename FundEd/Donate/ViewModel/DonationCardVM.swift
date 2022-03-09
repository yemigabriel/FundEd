//
//  DonationCardVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/9/22.
//

import Foundation

class DonationCardVM: ObservableObject {
    @Published private var donation: Donation
    
    var amount: String {
        "\(donation.amount)"
    }
    
    var projectTitle: String {
        donation.project?.title ?? donation.projectTitle
    }
    
    var donorName: String {
        donation.donorName
    }
    
    var createdAt: String {
        donation.createdAt.formattedShortDate()
    }
    
    init(donation: Donation) {
        self.donation = donation
    }
    
}
