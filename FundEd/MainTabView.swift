//
//  MainTabView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "homekit")
                }
            
            Text("Explore")
                .padding()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
            
            Text("Apply")
                .padding()
                .tabItem {
                    Label("Apply", systemImage: "square.and.arrow.up")
                }
            
            Text("Hello, world!")
                .padding()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
