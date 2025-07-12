//
//  RegisterViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    private let userRepository: UserRepositoryProtocol
    @Published var showAlert: Bool = false
    @Published var shouldReturnToLogin: Bool = false
    var alertMessage: String = ""
    var alertTitle: String = ""
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }
    
    // MARK: - Variables
    @Published var passwordSecurityLevel: PasswordSecurityLevel?
    @Published var isPasswordsMatching: Bool?
    @Published var isValidEmail: Bool?
    @Published var profileImage: UIImage?
    @Published var name: String = ""
   
    @Published var birthDate: Date = Date()
    
    // MARK: - Didsets variables
    @Published var password: String = "" {
        didSet {
            passwordSecureLevel(password)
            isPasswordsMatching = isPasswordMatchingFunction()
            if password.isEmpty {
                passwordSecurityLevel = Optional.none
            }
        }
    }
    @Published var repeatPassword: String = "" {
        didSet {
            isPasswordsMatching = isPasswordMatchingFunction()
        }
    }
    
    @Published var email: String = "" {
        didSet {
            isValidEmail = isValidEmailFunction(email)
            if email.isEmpty {
                isValidEmail = Optional.none
            }
        }
    }

    // MARK: - Password Functions
    func isPasswordMatchingFunction() -> Bool {
        return password == repeatPassword
    }
    
    
    func passwordSecureLevel(_ password: String) {
        let length = password.count

        // Regex helpers
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasDigit     = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSymbol    = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil

        if length >= 12 && hasUppercase && hasDigit && hasSymbol {
            passwordSecurityLevel = .strong
        } else if length >= 8 && (hasUppercase || hasDigit) {
            passwordSecurityLevel = .medium
        } else {
            passwordSecurityLevel = .weak
        }
    }
    
    // MARK: - Email Functions

    func isValidEmailFunction(_ email: String) -> Bool {
        // Regex relativamente estricto para emails “comunes”
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    // MARK: - Birthdate Functions
    func isAtLeastTenYearsOld() -> Bool {
        let tenYearsAgo = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        return birthDate <= tenYearsAgo
    }
    
    // MARK: - SignUp Functions
    func signUp() async {
        
        do {
            try validateFields()
            
            let newUser = User(
                id: UUID(),
                name: name,
                email: email,
                birthDate: birthDate,
                pets: [],
                profileImage: profileImage
            )
            
            let success = await userRepository.saveUser(newUser)
            await MainActor.run {
                self.alertTitle = success ? "Success" : "Error"
                self.alertMessage = success ? "Successfull registration!" : "An error occurred while registering."
                self.showAlert = true
            }
        } catch {
            alertTitle = "Error"
            alertMessage = (error as? SignUpValidationError)?.errorDescription ?? "Unknown error."
            showAlert = true
        }
    }
    
    func validateFields() throws {
        try validateName()
        try validateEmail()
        try validateBirthdate()
        try validatePassword()
        try validatePasswordMatch()
    }
    
    private func validateName() throws {
        guard !name.isEmpty else { throw SignUpValidationError.emptyName }
    }

    private func validateEmail() throws {
        guard !email.isEmpty else { throw SignUpValidationError.emptyEmail }
        guard isValidEmailFunction(email) else { throw SignUpValidationError.invalidEmail }
    }

    private func validateBirthdate() throws {
        guard isAtLeastTenYearsOld() else { throw SignUpValidationError.invalidBirthdate }
    }

    private func validatePassword() throws {
        guard !password.isEmpty else { throw SignUpValidationError.emptyPassword }
        guard let level = passwordSecurityLevel, level != .weak else { throw SignUpValidationError.weakPassword }
    }

    private func validatePasswordMatch() throws {
        guard let passwordMatching = isPasswordsMatching, passwordMatching else {
            throw SignUpValidationError.passwordMismatch
        }
    }

}

enum SignUpValidationError: LocalizedError {
    case emptyName, emptyEmail, invalidEmail, emptyPassword, weakPassword, passwordMismatch, invalidBirthdate
    
    var errorDescription: String? {
        switch self {
        case .emptyName: return "Name cannot be empty."
        case .emptyEmail: return "Email cannot be empty"
        case .invalidEmail: return "Invalid email format"
        case .emptyPassword: return "Password cannot be empty"
        case .weakPassword: return "Password is weak"
        case .passwordMismatch: return "Passwords do not match"
        case .invalidBirthdate: return "You must be at least 10 years old"
        }
    }
}
