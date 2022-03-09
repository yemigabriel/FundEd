//
//  ProjectListVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import Combine

class ProjectListVM: ObservableObject {
    @Published var filteredProjects: [Project] = []
    private var allProjects: [Project] = []
    @Published var searchFilter: String = ""
    private var projectService: ProjectServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var appState: AppState = .loading
    @Published var errorMessage: String = ""
    
    
    lazy var user: User? = {
        return UserDefaults.standard.getUser()
    }()
    
    @Published var isAdmin: Bool
    @Published var isUser: Bool
    
    init(isAdmin: Bool = false,
         isUser: Bool = false,
         projectService: ProjectServiceProtocol = ProjectService.shared) {
        
        self.isAdmin = isAdmin
        self.isUser = isUser
        self.projectService = projectService
        
        projectService.projectsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.appState = .error
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("completion: \(completion)")
                }
            }, receiveValue: { [weak self] projects in
                guard let self = self else { return }
                self.allProjects = projects.sorted(by: {$0.createdAt > $1.createdAt})
                self.filteredProjects = self.allProjects
                self.appState = .ready
            })
            .store(in: &cancellables)
        
        $searchFilter
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.4, scheduler: DispatchQueue.main, options: nil)
            .map { filter in
                filter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                self.allProjects :
                self.allProjects.filter{$0.title.contains(filter) || $0.shortDescription.contains(filter)}
            }
            .assign(to: &$filteredProjects)
    }
    
    func getProjects() {
        projectService.getProjects(limit: 20)
    }
    
    func getMyProjects() {
        if let user = user {
            projectService.getProjects(for: user.id)
        }
    }
    
    func getAllProjects() {
        projectService.getProjects(limit: 100)
    }
    
}

enum AppState {
    case loading, error, ready
}
