//
//  ExploreVM.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/8/22.
//

import Foundation
import Combine

class ExploreVM: ObservableObject {
    @Published var searchFilter: String = ""
    @Published var filteredResults: [Project] = []
    
    init() {
        
    }
}
