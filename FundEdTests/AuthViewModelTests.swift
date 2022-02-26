//
//  AuthViewModelTests.swift
//  FundEdTests
//
//  Created by Yemi Gabriel on 2/26/22.
//

import XCTest
@testable import FundEd

class AuthViewModelTests: XCTestCase {
    
    var sut: AuthViewModel!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService.shared
        sut = .init(authService: mockAuthService)
    }
    
    override func tearDown() {
        mockAuthService = nil
        sut = nil
        super.tearDown()
    }
    
    func testEmailValidation() {
        sut.email = "abc@abc.com"
        XCTAssertTrue(sut.isValidEmail(sut.email), "A valid email is required")
    }
    
    func testSignInValidation() {
        sut.email = "abc@abc.com"
        sut.password = "123456"
        XCTAssertGreaterThanOrEqual(sut.password.trimmingCharacters(in: .whitespacesAndNewlines).count, 6, "Password cannot be less than 6 characters")
        XCTAssertTrue(sut.isValidSignIn())
    }
    
    func testSignUpValidation() {
        sut.name = "kim"
        sut.email = "abc@abc.com"
        sut.password = "123456"
        sut.confirmPassword = "123456"
        sut.role = .donor
        
        XCTAssertFalse(sut.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, "Name cannot be empty")
        XCTAssertTrue(sut.isValidEmail(sut.email), "A valid email is required")
        XCTAssertGreaterThanOrEqual(sut.password.trimmingCharacters(in: .whitespacesAndNewlines).count, 6, "Password cannot be less than 6 characters")
        XCTAssertEqual(sut.password.trimmingCharacters(in: .whitespacesAndNewlines), sut.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines), "Passwords must match")
        XCTAssertNotEqual(sut.role, UserRole.selectRole,  "A user role must be selected")
        
        XCTAssertTrue(sut.isValidSignUp())
    }
    
    func testSignInWithPassword_IsSuccessful() {
        sut.email = "abc@abc.com"
        sut.password = "123456"
        
        mockAuthService.signIn(email: sut.email, password: sut.password)
        
        XCTAssertNotNil(sut.user, "New user was not loggedIn")
        XCTAssertEqual(sut.user?.email, sut.email)
    }
    
        func testSignUpWithPassword_IsSuccessful() {
            sut.name = "kim"
            sut.email = "abc@abc.com"
            sut.password = "123456"
            sut.confirmPassword = "123456"
            sut.role = .donor
            
            let user = User(id: "id", name: sut.name, email: sut.email, password: sut.password, role: sut.role.rawValue)
            mockAuthService.signUp(user)
    
            XCTAssertNotNil(sut.user, "New user was not created")
            XCTAssertEqual(sut.user?.email, sut.email)
        }
    
    
}
