//
//  ProjectDetailVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation

class ProjectCardVM: ObservableObject {
    @Published var project: Project
    
    init(project: Project) {
        self.project = project
    }
    
}
