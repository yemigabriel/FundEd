//
//  AddDonationVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddDonationVM: ObservableObject {
    @Published var donation: Donation?
    @Published var amount: Double = 0.00
    @Published var comment: String = ""
    @Published var projectId: String = ""
    @Published var donorId: String = ""
    @Published var donorName: String = ""
    
    private var donationService: DonationService
    
    init(projectId: String, donationService: DonationServiceProtocol = DonationService.shared){
        
    }
    
}
