//
//  AddDonationVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//
import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddDonationVM: ObservableObject {
    var donations: [Donation] = []
    @Published var amount: String = "0.0"
    @Published var amountLeft: Double = 0.0
    @Published var comment: String = ""
    @Published var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published var proceedToPayment: Bool = false
    @Published var project: Project
    @Published var isPaymentSuccessful: Bool = false
    @Published var isDonationSuccessful: Bool = false
    
    
    var paymentUrl: String {
        guard let amount = Double(amount) else { return "" }
        return "\(AppConstants.basePaymentUrl)email=\(donorEmail)&amount=\(amount))"
    }
    
    private var donationService: DonationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private var donorId: String {
        return UserDefaults.standard.getUser()?.id ?? ""
    }
    
    private var donorEmail: String {
        return UserDefaults.standard.getUser()?.email ?? ""
    }
    
    private var donorName: String {
        return UserDefaults.standard.getUser()?.name ?? ""
    }
    
    init(project: Project, amountLeft: Double, donationService: DonationServiceProtocol = DonationService.shared){
        self.project = project
        self.amountLeft = amountLeft
        self.donationService = donationService
        
        donationService.donationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.hasError.toggle()
                case .finished:
                    break
                }
            } receiveValue: { [weak self] donation in
                if let _ = donation.id {
                    self?.isDonationSuccessful.toggle()
                }
            }
            .store(in: &cancellables)
    }
    
    
    
    func isValidDonation() -> Bool {
        project.id!.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        donorId.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        donorName.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        Double(amount) ?? 0.0 > 0.0 &&
        Double(amount) ?? 0.0 <= amountLeft
    }
    
    func donate() {
        let donation = Donation(projectId: project.id!,
                                projectTitle: project.title,
                                donorId: donorId,
                                donorName: donorName,
                                amount: Double(amount) ?? 0.0,
                                comment: comment,
                                verified: false,
                                createdAt: Date.now,
                                updatedAt: Date.now)
        donationService.donate(donation)
    }
    
    func payWithPayStack() {
    }
    
}

enum AppConstants {
    static let basePaymentUrl = "https://serene-sinoussi-adb657.netlify.app/pystk_funded.html?"
}


