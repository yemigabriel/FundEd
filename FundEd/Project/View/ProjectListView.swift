//
//  ProjectListView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectListVM()
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 50)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 50)  {
            if viewModel.appState == .loading {
                ProgressView("Fetching projects...")
            }
            ForEach(viewModel.projects, id: \.id) { project in
                NavigationLink {
                    ProjectDetailView(viewModel: .init(project: project))
                } label: {
                    ProjectCardView(viewModel: .init(project: project))
                }
                .buttonStyle(.plain)
            }
        }
        .alert(isPresented: .constant(viewModel.appState == .error), content: {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
        })
        .onAppear {
            viewModel.getProjects()
        }
        
        

    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
