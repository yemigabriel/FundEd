//
//  SignupView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/17/22.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "books.vertical.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 75)
                .padding(.vertical, 40)
            
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TogglePasswordField(password: $viewModel.password, label: "Password")
            
            TogglePasswordField(password: $viewModel.confirmPassword, label: "Confirm Password")
            
            Picker("Select Role:", selection: $viewModel.role) {
                ForEach(UserRole.allCases, id: \.self) { role in
                    Text("\(role.rawValue)")
                }
            }
            .padding(.horizontal)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.accentColor, lineWidth: 1))
            
            Button("Sign up") {
                print("signup")
                if viewModel.isValidSignUp() {
                    viewModel.signUp()
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
                Text("Already have an account?")
                Button("Log in") {
                    print("login")
                    viewModel.authState = .login
                }
            }
            
            Spacer()
            
        }
        .padding()
        .sheet(item: $viewModel.user) {
            print("dismissed")
        } content: { user in
            Text("Successfully created new user: \(user.name) \(user.email)")
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(viewModel: AuthViewModel())
    }
}
