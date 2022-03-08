//
//  ProjectDetailVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import Combine
import Foundation

class ProjectDetailVM: ObservableObject {
    @Published var project: Project
    @Published var projectMaterials: [ProjectMaterial] = []
    @Published var appState: AppState = .loading
    @Published var errorMessage: String = ""
    @Published var currentTotalDonation: Double = 0.00
    @Published var isDonateActive = false
    @Published var showLogin = false
    
    @Published var showEditView = false
    @Published var showDeleteAlert = false
    
    private var projectService: ProjectServiceProtocol
    private var donationService: DonationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var isAuthor: Bool {
        if let savedUser = UserDefaults.standard.getUser() {
            return savedUser.id == project.authorId
        }
        return false
    }
    
    var isLoggedIn: Bool {
        if let _ = UserDefaults.standard.getUser() {
            return true
        }
        return false
    }
    
    init(project: Project,
         projectService: ProjectServiceProtocol = ProjectService.shared,
         donationService: DonationServiceProtocol = DonationService.shared) {
        self.project = project
        self.projectService = projectService
        self.donationService = donationService
        setUpPublishers()
    }
    
    func setUpPublishers() {
        projectService.projectPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.appState = .error
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("completion: \(completion)")
                }
            } receiveValue: { [weak self] project in
                print("receiving project")
                self?.project = project
//                self?.appState = .ready
            }
            .store(in: &cancellables)
        
        projectService.projectMaterialsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.appState = .error
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("completion: \(completion)")
                }
            } receiveValue: { [weak self] projectMaterials in
                print("receiving project materials")
                self?.projectMaterials = projectMaterials
                self?.appState = .ready
            }
            .store(in: &cancellables)
        
        donationService.donationsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.appState = .error
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("completion: \(completion)")
                }
            } receiveValue: { [weak self] donations in
                let totalDonationAmount = donations.reduce(0.0){ $0 + $1.amount}
                print("TOTAL DONATION: \(totalDonationAmount)")
                self?.currentTotalDonation = totalDonationAmount
            }
            .store(in: &cancellables)

        
    }
    
    func getProjectDetails() {
        projectService.getProject(projectId: project.id!)
    }
    
    func getMaterials() {
        projectService.getMaterials(for: project.id!)
    }
    
    func getDonations() {
        donationService.getDonations(for: project.id!)
    }
    
    func deleteProject() {
        projectService.delete(project: project)
    }
    
}
