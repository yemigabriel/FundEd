//
//  EditProjectVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/7/22.
//

import Foundation
import Combine

class EditProjectVM: ObservableObject {
    @Published var project: Project
    @Published var projectMaterials: [ProjectMaterial]
    
    @Published var choosesImage: Bool = false
    @Published var selectedImageData: Data?
    
    @Published var allSchools: [School] = School.allSchools
    @Published var schoolFilter: String = ""
    @Published var filteredSchools: [School] = []
    
    @Published var appState: AppState = .ready
    @Published var errorMessage: String = ""
    @Published var loadingMessage: String = ""
    @Published var isSuccessful: Bool = false
    
    private var imageUploadService: ImageUploadServiceProtocol
    private var projectService: ProjectServiceProtocol
    
    var totalAmount: Double {
        projectMaterials.reduce(0, {$0 + $1.totalAmount})
    }
    
    lazy var user: User? = {
        return UserDefaults.standard.getUser()
    }()
    
    var cancellables = Set<AnyCancellable>()
    
    
    init(project: Project,
         projectMaterials: [ProjectMaterial],
         imageUploadService: ImageUploadServiceProtocol = ImageUploadService.shared,
         projectService: ProjectServiceProtocol = ProjectService.shared) {
        self.project = project
        self.projectMaterials = projectMaterials
        self.imageUploadService = imageUploadService
        self.projectService = projectService
        
        projectService.projectPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.appState = .error
                    self?.errorMessage = "\(error)"
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] project in
                self?.isSuccessful.toggle()
            }
            .store(in: &cancellables)
        
        imageUploadService.imageUrlPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.appState = .error
                    self?.errorMessage = "\(error)"
                    print("From publisher: ", error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] imagePath in
                self?.project.photoPath = imagePath
                self?.resetAppState()
            }
            .store(in: &cancellables)
        
        $schoolFilter
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map{ filter in
                print(filter)
                return Array(self.allSchools.filter({filter == "" ? false : $0.name.lowercased().contains(filter.lowercased())}).prefix(40))
            }
            .assign(to: &$filteredSchools)

    }
    
    func resetAppState() {
        loadingMessage = ""
        errorMessage = ""
        appState = .ready
    }
    
    func addMaterial() {
        if projectMaterials.last!.item.isNotEmpty() {
            projectMaterials.append(ProjectMaterial(item: "", quantity: 1, cost: 0.00, projectId: ""))
        }
    }
    
    func removeMaterial(_ material: ProjectMaterial) {
        if projectMaterials.count > 1 {
           projectMaterials.removeAll(where: {$0.id == material.id})
        }
    }
    
    func isValidProject() -> Bool {
        return project.title.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        project.shortDescription.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        project.description.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        project.schoolId > 0 &&
        projectMaterials.count > 0 &&
        projectMaterials.contains(where: {$0.item.isNotEmpty() && $0.cost > 0}) &&
        project.amount > 0 &&
        project.photoPath.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty()
    }
    
    func update() {
        projectService.update(project: project, with: projectMaterials)
    }
    
    func uploadImage() {
        loadingMessage = "Uploading image ..."
        appState = .loading
        if let selectedImageData = selectedImageData {
            imageUploadService.upload(imageData: selectedImageData)
        }
    }
    
    
}

