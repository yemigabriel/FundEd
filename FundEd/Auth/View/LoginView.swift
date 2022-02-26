//
//  LoginView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/17/22.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        
        VStack(spacing: 20){
            Image(systemName: "books.vertical.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 75)
                .padding(.vertical, 40)
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TogglePasswordField(password: $viewModel.password, label: "Password")
            
            Button("Login") {
                print("login")
                if viewModel.isValidSignIn() {
                    viewModel.signIn()
                } else {
                    viewModel.hasError.toggle()
                }
            }
            .padding()
            .frame(width: 200, alignment: .center)
            .foregroundColor(Color(uiColor: UIColor.systemBackground))
            .background(Color.accentColor)
            .clipShape(Capsule())
            .font(.headline)
            
            HStack {
                Text("Don't have an account?")
                Button("Sign up") {
                    print("Sign up")
                    viewModel.authState = .signup
                }
            }
            
            Spacer()
            
        }
        .onReceive(viewModel.$user, perform: { user in
            guard let user = user else { return }
            print("Successfully logged in \(user.name) \(user.email)")
        })
        .sheet(item: $viewModel.user) {
            print("dismissed")
        } content: { user in
            Text("Successfully logged in \(user.name) \(user.email)")
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
        .padding()
        

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel())
    }
}

struct TogglePasswordField: View {
    @State var showPassword: Bool = false
    @Binding var password: String
    var label: String
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if showPassword {
                TextField(label, text: $password )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                SecureField(label, text: $password )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: {
                showPassword.toggle()
            }) {
                Image(systemName: self.showPassword ? "eye" : "eye.slash")
                    .accentColor(.black.opacity(0.7))
                    .offset(x: -10)
            }
        }
    }
}
