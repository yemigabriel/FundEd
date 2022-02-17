//
//  ContentView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 8/14/21.
//

import SwiftUI

struct ContentView: View {
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
                    Label("Account", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
