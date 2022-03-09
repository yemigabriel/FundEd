//
//  DonationVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/9/22.
//

import Foundation
import Combine

class DonationListVM: ObservableObject {
    
    @Published var donations: [Donation] = []
    @Published var filteredDonations: [Donation] = []
    @Published var searchFilter: String = ""
    
    @Published var appState: AppState = .loading
    @Published var errorMessage: String = ""
    
    @Published var isAdmin: Bool
    @Published var isUser: Bool
    
    lazy var user: User? = {
        return UserDefaults.standard.getUser()
    }()
    
    private var donationService: DonationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(isAdmin: Bool = false,
         isUser: Bool = false,
         donationService: DonationServiceProtocol = DonationService.shared) {
        self.isAdmin = isAdmin
        self.isUser = isUser
        self.donationService = donationService
        
        donationService.donationsPublisher
            .receive(on: DispatchQueue.main, options: nil)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] donations in
                self?.donations = donations
                self?.filteredDonations = donations
                self?.appState = .ready
            }
            .store(in: &cancellables)
        
        $searchFilter
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.4, scheduler: DispatchQueue.main, options: nil)
            .map { [weak self] filter in
                guard let self = self else { return []}
                return filter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                self.donations :
                self.donations.filter{ $0.projectTitle.contains(filter) }
            }
            .assign(to: &$filteredDonations)

    }
    
    func getDonations() {
        donationService.getDonations()
    }
    
    func getUserDonations() {
        if let user = user {
            donationService.getUserDonations(user.id)
        }
    }
}
