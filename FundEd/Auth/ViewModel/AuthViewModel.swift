//
//  AuthViewModel.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/17/22.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var role: UserRole = .selectRole
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    
    private var authService: AuthServiceProtocol!
    @Published var user: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
        authService.userPublisher.sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.hasError = true
            case .finished:
                print("completion: \(completion)")
            }
        } receiveValue: { [weak self] user in
            self?.user = user
            self?.authState = .currentUser
        }
        .store(in: &cancellables)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidSignIn() -> Bool {
        if !isValidEmail(email.trimmingCharacters(in: .whitespacesAndNewlines)) {
            errorMessage = "Please type in a valid email address"
            return false
        }
        if password.trimmingCharacters(in: .whitespacesAndNewlines).count < 6 {
            errorMessage = "Please type in a password with at least 6 characters"
            return false
        }
        errorMessage = ""
        return true
    }
    
    func isValidSignUp() -> Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Please type in your name"
            return false
        }
        if !isValidEmail(email) {
            errorMessage = "Please type in a valid email address"
            return false
        }
        if password.trimmingCharacters(in: .whitespacesAndNewlines).count < 6 {
            errorMessage = "Please type in a password with at least 6 characters"
            return false
        }
        if password != confirmPassword {
            errorMessage = "Your passwords do not match"
            return false
        }
        if role == .selectRole {
            errorMessage = "Please select a role"
            return false
        }
        
        errorMessage = ""
        return true
    }
    
    func signIn() {
        authService.signIn(email: email, password: password)
    }
    
    func signUp() {
        let user = User(id: "id", name: name, email: email, password: password, role: role.rawValue)
        authService.signUp(user)
    }
    
    func signOut() {
        authService.signOut()
        authState = .login
        self.user = nil
    }
    
    
}

enum AuthError: Error {
    case requiredField
    case invalidEmail
    case passwordMismatch
    case emailAlreadyExisits
    case wrongPassword
}

enum UserRole: String, CaseIterable {
    case selectRole = "Please select your role"
    case teacher = "Teacher"
    case donor = "Donor"
    case admin = "Administrator"
}

enum AuthState {
    case login
    case signup
    case forgotPassword
    case resetPassword
    case currentUser
}
