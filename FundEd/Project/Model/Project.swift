//
//  Project.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Project: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let shortDescription: String
    let description: String
    let photoPath: String
    let authorId: String
    let authorName: String
    let schoolId: Int
    let amount: Double
    let approved: Bool?
    let status: String?
    let createdAt: Date
    let updatedAt: Date
    
    var photoUrl: URL? {
        URL(string: photoPath)
    }
    
    var school: School? {
        let schools: [School] = Bundle.main.decode("schools_lagos.json")
        return schools.first(where: {$0.id == schoolId})
    }
}

extension Project {
    static let placeholderUrl: String = "https://plchldr.co/i/500x200?bg=cccccc&text=..."
     static var sample: Project {
        Project(id: UUID().uuidString,
                title: "Chairs For Classroom",
                shortDescription: "Chairs For Classroom",
                description: """
                           Chairs For Classroom \n
                           Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                           """,
                photoPath: "https://27mi124bz6zg1hqy6n192jkb-wpengine.netdna-ssl.com/wp-content/uploads/2020/05/Classroom-Management-for-an-Effective-Learning-Environment-scaled.jpg",
                authorId: "authorId",
                authorName: "Mr. Bayode",
                schoolId: 1987,
                amount: 20000.00,
                approved: true,
                status: ProjectStatus.ongoing.rawValue,
                createdAt: Date.now,
                updatedAt: Date.now)
     }
    
    static var sampleList: [Project] {
        var list = [Project]()
        for _ in 0...3 {
            list.append(sample)
        }
        return list
    }
}

extension Project {
    init(title: String,
         shortDescription: String,
         description: String,
         photoPath: String,
         schoolId: Int,
         amount: Double,
         author: User) {
        self.title = title
        self.shortDescription = shortDescription
        self.description = description
        self.photoPath = photoPath
        self.schoolId = schoolId
        self.amount = amount
        self.authorId = author.id
        self.authorName = author.name
        self.approved = false
        self.status = ProjectStatus.ongoing.rawValue
        self.createdAt = Date.now
        self.updatedAt = Date.now
    }
}

enum ProjectStatus: String {
    case complete = "complete"
    case ongoing = "ongoing"
    case banned = "banned"
}

enum FirebaseError: Error {
    case firestoreError(error: String)
    case documentNotExists(error: String)
    case dataDecodingError(error: String)
    case firebaseAuth(error: String)
    case userNotExists(error: String)
    case imageUploadError(error: String)
    case imageDownloadError(error: String)
}
