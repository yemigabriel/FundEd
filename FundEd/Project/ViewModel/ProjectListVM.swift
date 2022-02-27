//
//  ProjectListVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import Combine

class ProjectListVM: ObservableObject {
    @Published var projects: [Project] = []
    private var projectService: ProjectServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var appState: AppState = .loading
    @Published var errorMessage: String = ""
    
    init(projectService: ProjectServiceProtocol = ProjectService.shared) {
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
                self?.projects = projects
                self?.appState = .ready
            })
            .store(in: &cancellables)
    }
    
    func getProjects() {
        projectService.getProjects()
    }
    
}

enum AppState {
    case loading, error, ready
}
