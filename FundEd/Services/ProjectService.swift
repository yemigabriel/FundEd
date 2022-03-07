//
//  ProjectService.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift


protocol ProjectServiceProtocol {
    var projectsPublisher: CurrentValueSubject<[Project], FirebaseError> { get }  //Published<[Project]>.Publisher {get}
    var projectPublisher: PassthroughSubject<Project, FirebaseError> { get }
    var projectMaterialsPublisher: PassthroughSubject<[ProjectMaterial], FirebaseError> { get }
    func getProjects()
    func getMaterials(for projectId: String)
    func getProject(projectId: String)
    func update(project: Project)
//    func add(project: Project)
//    func add(_ materials: [ProjectMaterial], for projectId: String)
    func add(project: Project, with materials: [ProjectMaterial])
}

class ProjectService: ObservableObject, ProjectServiceProtocol {
    
    static let shared = ProjectService()
    var projectsPublisher = CurrentValueSubject<[Project], FirebaseError>([])
    var projectPublisher = PassthroughSubject<Project, FirebaseError>()
    var projectMaterialsPublisher = PassthroughSubject<[ProjectMaterial], FirebaseError>()
    
    private let store = Firestore.firestore()
    private let projectCollection = "projects"
    private let projectMaterialCollection = "project_materials"
    
    private init() {}
    
    func getProjects() {
        store.collection(projectCollection)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.projectsPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
                    return
                }
                let projects = snapshot?.documents.compactMap({ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Project.self)
                }) ?? []
                self?.projectsPublisher.send(projects)
            }
    }
    
    func getMaterials(for projectId: String) {
        store.collection(projectMaterialCollection)
            .whereField("projectId", isEqualTo: projectId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.projectMaterialsPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
                    return
                }
                let projectMaterials = snapshot?.documents.compactMap({ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: ProjectMaterial.self)
                }) ?? []
                self?.projectMaterialsPublisher.send(projectMaterials)
            }
    }
    
    func getProject(projectId: String) {
        store.collection(projectCollection)
            .document(projectId)
            .getDocument{ snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    self.projectPublisher.send(completion: .failure(.firestoreError(error: error!.localizedDescription)))
                    return
                }
                
                do {
                    if let project = try snapshot.data(as: Project.self) {
                        self.projectPublisher.send(project)
                    } else {
                        self.projectPublisher.send(completion: .failure(.documentNotExists(error: "Project does not exist")))
                    }
                } catch {
                    print(error.localizedDescription)
                    self.projectPublisher.send(completion: .failure(.dataDecodingError(error: error.localizedDescription)))
                }
            }
    }
    
    func add(_ materials: [ProjectMaterial], for projectId: String) {
        
        let projectMaterials = materials.map{ProjectMaterial(item: $0.item, quantity: $0.quantity, cost: $0.cost, projectId: projectId)}
        
        let docRef = store.collection(projectMaterialCollection).document()
        let batch = store.batch()
        do {
           try projectMaterials.forEach { projectMaterial in
                try batch.setData(from: projectMaterial, forDocument: docRef)
            }
            print("materials batched")
        } catch {
            print(error.localizedDescription)
            projectMaterialsPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
        }
        
        batch.commit { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.projectMaterialsPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
                return
            }
            self?.projectMaterialsPublisher.send(materials)
        }
    }
    
    func add(project: Project) {
        do {
            _ = try store.collection(projectCollection).addDocument(from: project)
            projectPublisher.send(project)
        } catch {
            print(error.localizedDescription)
            projectPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
        }
    }
    
    func add(project: Project, with materials: [ProjectMaterial]) {
        
        print("materials: service-  ", materials)
        
        do {
            //project doc
            let projectRef = try store.collection(projectCollection).addDocument(from: project)
            let projectMaterials = materials.map{ProjectMaterial(item: $0.item, quantity: $0.quantity, cost: $0.cost, projectId: projectRef.documentID)}
            
            let batch = store.batch()
            try projectMaterials.forEach { projectMaterial in
                let materialsRef = store.collection(projectMaterialCollection).document()
                try batch.setData(from: projectMaterial, forDocument: materialsRef)
                print("batching: \(projectMaterial.id) - \(projectMaterial.item)")
            }
            print("materials batched")
            
            batch.commit { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                    self?.projectPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
                    return
                }
                self?.projectPublisher.send(project)
            }
        } catch {
            print(error.localizedDescription)
            projectPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
        }
    }
    
    func update(project: Project) {
        guard let documentId = project.id else { return }
        do {
            try store.collection(projectCollection)
                .document(documentId)
                .setData(from: project, merge: true)
            projectPublisher.send(project)
        } catch {
            print(error.localizedDescription)
            projectPublisher.send(completion: .failure(.firestoreError(error: error.localizedDescription)))
        }
    }
    
    
}
