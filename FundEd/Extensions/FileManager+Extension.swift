//
//  FileManager+Extension.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import Foundation

extension FileManager {
    
    static let IMAGES_FOLDER = "Funded/Photos"
    
    func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getSavedImagesFolder() -> URL {
        let savedImagesFolder = getDocumentDirectory().appendingPathComponent(FileManager.IMAGES_FOLDER)
        if !FileManager.default.fileExists(atPath: savedImagesFolder.path) {
            do {
                try FileManager.default.createDirectory(at: savedImagesFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        return savedImagesFolder
    }
    
}
