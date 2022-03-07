//
//  DonationService.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift


protocol DonationServiceProtocol {
    var donationsPublisher: CurrentValueSubject<[Donation], FirebaseError> { get }
    var donationPublisher: PassthroughSubject<Donation, FirebaseError>{ get }
    func getDonations(for projectId: String)
    func getUserDonations(_ userId: String)
    func donate(_ donation: Donation)
}

class DonationService: ObservableObject, DonationServiceProtocol {
    
    static let shared = DonationService()
    var donationsPublisher = CurrentValueSubject<[Donation], FirebaseError>([])
    var donationPublisher = PassthroughSubject<Donation, FirebaseError>()
    
    private let store = Firestore.firestore()
    private let donationCollection = "donations"
    
    private init() {}
    
    func getDonations(for projectId: String) {
        store.collection(donationCollection)
            .whereField("projectId", isEqualTo: projectId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.donationsPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
                    return
                }
                let donations = snapshot?.documents.compactMap({ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Donation.self)
                }) ?? []
                self?.donationsPublisher.send(donations)
            }
    }
    
    func getUserDonations(_ userId: String) {
        store.collection(donationCollection)
            .whereField("donorId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.donationsPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
                    return
                }
                let donations = snapshot?.documents.compactMap({ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Donation.self)
                }) ?? []
                self?.donationsPublisher.send(donations)
            }
    }
    
    func donate(_ donation: Donation) {
        do {
            let ref = try store.collection(donationCollection).addDocument(from: donation)
            ref.getDocument { [weak self] snapshot, error in
                if let donation = try? snapshot?.data(as: Donation.self) {
                    self?.donationPublisher.send(donation)
                }
            }
        } catch {
            print(error.localizedDescription)
            donationsPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
        }
    }
    
    
}
