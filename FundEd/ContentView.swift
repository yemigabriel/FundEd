//
//  ContentView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 8/14/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        if viewRouter.isNewUser {
            Text("Onboarding")
                .onAppear {
                    viewRouter.isNewUser = false
                }
        } else {
            MainTabView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
