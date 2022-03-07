//
//  PhotoPickerController.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import SwiftUI
import PhotosUI

struct PhotoPickerController: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    
    init(imageData: Binding<Data?>) {
        _imageData = imageData
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: PhotoPickerController
        
        init(_ parent: PhotoPickerController) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else { return }
                    guard let data = image.jpegData(compressionQuality: 0.8) else { return }
                    DispatchQueue.main.async {
                        self?.parent.imageData = data
                    }
                }
            }
        }
        
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
}
