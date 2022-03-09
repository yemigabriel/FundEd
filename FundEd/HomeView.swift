//
//  HomeView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 8/24/21.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView() {
            ScrollView {
                ProjectListView()
            }
            .padding()
            .background(Color(uiColor: .systemGray6))
            .navigationTitle("Home")
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
