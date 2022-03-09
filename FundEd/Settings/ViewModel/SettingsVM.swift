//
//  File.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/8/22.
//

import Foundation
import Combine

class SettingsVM: ObservableObject {
    @Published var userRole: UserRole = .teacher
    private var authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    let termsOfUse = ""
    let privacyPolicy = ""
    
    var isLoggedIn: Bool {
        if let _ = UserDefaults.standard.getUser() {
            return true
        }
        return false
    }
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
        authService.userPublisher
            .receive(on: DispatchQueue.main, options: nil)
            .sink { completion in
                switch completion {
                case.finished:
                  break
                case .failure(_):
                    break
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)

        if let currentUser = UserDefaults.standard.getUser() {
            if let role = currentUser.role {
                userRole = UserRole.init(rawValue: role) ?? .teacher
                print(role)
            }
        }
    }
    
    func signOut() {
        authService.signOut()
    }
}
