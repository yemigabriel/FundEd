//
//  AddProjectVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import Foundation
import Combine

class AddProjectVM: ObservableObject {
    @Published var choosesImage: Bool = false
    @Published var selectedImageData: Data?
    @Published var uploadedImageUrl: String = ""
    @Published var projectId: String = UUID().uuidString
    @Published var title: String = ""
    @Published var shortDescription: String = ""
    @Published var description: String = ""
    @Published var allSchools: [School] = School.allSchools
    @Published var school: School = School.emptySchool
    @Published var schoolFilter: String = ""
    @Published var filteredSchools: [School] = []
    @Published var projectMaterials: [ProjectMaterial] = [ProjectMaterial.empty]
    
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
    
    init(imageUploadService: ImageUploadServiceProtocol = ImageUploadService.shared,
         projectService: ProjectServiceProtocol = ProjectService.shared) {
        
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
                self?.resetAppState()
                self?.isSuccessful.toggle()
                self?.resetForm()
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
                self?.uploadedImageUrl = imagePath
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
    
    func isValidProject() -> Bool {
        return title.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        shortDescription.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        description.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() &&
        school.id > 0 &&
        projectMaterials.count > 0 &&
        projectMaterials.contains(where: {$0.item.isNotEmpty() && $0.cost > 0}) &&
        totalAmount > 0 &&
        uploadedImageUrl.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty()
    }
    
    func getSchoolsBySearchFilter() {
        filteredSchools = Array(allSchools.filter({schoolFilter == "" ? false : $0.name.lowercased().contains(schoolFilter.lowercased())}).prefix(20))
    }
    
    func resetForm() {
        uploadedImageUrl = ""
        projectId = UUID().uuidString
        title = ""
        shortDescription = ""
        description = ""
        allSchools = School.allSchools
        school = School.emptySchool
        schoolFilter = ""
        filteredSchools = []
//        projectMaterials.removeAll()
        projectMaterials = [ProjectMaterial.empty]
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
    
    func addProject() {
        guard let user = user else { return }
        guard school.id > 0 else { return }
        let project = Project(title: title,
                              shortDescription: shortDescription,
                              description: description,
                              photoPath: uploadedImageUrl,
                              schoolId: school.id,
                              amount: totalAmount,
                              author: user)
        
        loadingMessage = "Starting project ..."
        appState = .loading
        print("materials: ", projectMaterials)
        projectService.add(project: project, with: projectMaterials)
    }
    
    func uploadImage() {
        loadingMessage = "Uploading image ..."
        appState = .loading
        if let selectedImageData = selectedImageData {
            imageUploadService.upload(imageData: selectedImageData)
        }
    }
    
}
