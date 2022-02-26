//
//  FundEdApp.swift
//  FundEd
//
//  Created by Yemi Gabriel on 8/14/21.
//

import SwiftUI
import Firebase

@main
struct FundEdApp: App {
    
    var viewRouter: ViewRouter
    init() {
        viewRouter = ViewRouter()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            //Check & switch btwn Onboarding and UserLoggedIn and Auth...
//            AuthView()
            ContentView()
                .environmentObject(viewRouter)
        }
    }
}
