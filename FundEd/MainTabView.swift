//
//  MainTabView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "homekit")
                }
            
//            ExploreView()
//                .tabItem {
//                    Label("Explore", systemImage: "magnifyingglass")
//                }
            
            AddProjectView()
                .tabItem {
                    Label("Create Project", systemImage: "note.text.badge.plus")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .environmentObject(viewRouter)
        }
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
