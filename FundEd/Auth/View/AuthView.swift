//
//  AuthView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/17/22.
//

import SwiftUI

struct AuthView: View {
    @StateObject var authViewModel = AuthViewModel()
//    @Environment(\.dismiss) var dismiss
    @State var hasHistory = false
    @Binding var shouldShowLogin: Bool
    
    var body: some View {
        ZStack {
            Group {
                if authViewModel.authState == .login {
                    LoginView(viewModel: authViewModel)
                }
                if authViewModel.authState == .signup {
                    SignupView(viewModel: authViewModel)
                }
                if authViewModel.authState == .currentUser && !hasHistory {
                    MainTabView()
                }
            }.onAppear {
                if hasHistory {
                    shouldShowLogin = false
                }
            }
            
            if authViewModel.appState == .loading {
                ProgressView()
                    .padding()
                    .foregroundColor(.white)
                    .tint(.white)
                    .background(.black.opacity(0.7))
                    .cornerRadius(10)
            }
            
        }
    }
}

//struct AuthView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthView()
//    }
//}
