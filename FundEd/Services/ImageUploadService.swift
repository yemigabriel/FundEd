//
//  ImageUploadService.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import Combine
import FirebaseStorage
import FirebaseStorageSwift


protocol ImageUploadServiceProtocol {
    var imageUrlPublisher: PassthroughSubject<String, FirebaseError> { get }
    func upload(imageData: Data)
}

//Firebase Image Service
class ImageUploadService: ImageUploadServiceProtocol {
    static let shared = ImageUploadService()
    var imageUrlPublisher = PassthroughSubject<String, FirebaseError>()
    
    let storage = Storage.storage()
    let projectImagesPath = "images/projects/"
    
    private init() {
    }
    
    func upload(imageData: Data) {
        guard let user = UserDefaults.standard.getUser() else { return }
        let imageName = user.id + Date.fileNameByTimestamp()
        let projectImageReference = storage.reference().child("\(projectImagesPath)\(imageName).jpg")
        
        let _ = projectImageReference.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let metadata = metadata else {
                self?.imageUrlPublisher.send(completion: .failure(.imageUploadError(error: error?.localizedDescription ?? "Something went wrong while uploading your image")))
                return
            }
            print("Size: \(metadata.size) \(metadata.dictionaryRepresentation())")
            
            //TODO: monitor upload progress
            self?.getFirebaseDownloadUrl(imageRef: projectImageReference)
        }
    }
    
    func getFirebaseDownloadUrl(imageRef: StorageReference) {
        imageRef.downloadURL { [weak self] url, error in
            guard let downloadUrl = url else {
                self?.imageUrlPublisher.send(completion: .failure(.imageDownloadError(error: error?.localizedDescription ?? "Something went wrong while fetching your image")))
                return
            }
            self?.imageUrlPublisher.send(downloadUrl.absoluteString)
        }
    }
    
}
