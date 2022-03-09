//
//  ExploreView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/8/22.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreVM()
    
    var body: some View {
        NavigationView {
            VStack {
//                Form {
//                }
                List {
                ProjectListView()
                }
            }
            .searchable(text: $viewModel.searchFilter)
            
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
