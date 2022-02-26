//
//  AuthView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/17/22.
//

import SwiftUI

struct AuthView: View {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.authState == .login {
            LoginView(viewModel: authViewModel)
        }
        if authViewModel.authState == .signup {
            SignupView(viewModel: authViewModel)
        }
        if authViewModel.authState == .currentUser {
            ContentView()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
