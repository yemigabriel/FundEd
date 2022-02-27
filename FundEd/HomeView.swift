//
//  HomeView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 8/24/21.
//

import SwiftUI

struct HomeView: View {
//    var columns: [GridItem] = [
//        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 50)
//    ]
    var body: some View {
        NavigationView() {
            ScrollView {
//                LazyVGrid(columns: columns, spacing: 50) {
//                    ForEach(0 ..< 20) { item in
//                        FundCardView(item: item)
//                    }
                    ProjectListView()
//                }
//                List(0 ..< 20) { item in
//                    FundCardView(item: item)
//                }
//                .listStyle(PlainListStyle())
                
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
