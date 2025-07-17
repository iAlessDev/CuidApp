//
//  LoginViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 11/07/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    
    private let userRepository: UserRepositoryProtocol
    private let credentialRepository: CredentialsRepositoryProtocol
    private let session: SessionManager
    
    
    init(
        session: SessionManager,
        userRepository: UserRepositoryProtocol = UserRepository(),
        credentialRepository: CredentialsRepositoryProtocol = KeychainHelper())
    {
        self.session = session
        self.userRepository = userRepository
        self.credentialRepository = credentialRepository
    }
    
    func signIn() async throws {
        let user = try await fetchUser()
        try verifyPassword()
        completeLogin(with: user)
      }
    
    private func fetchUser() async throws -> User {
        guard let user = try await userRepository.fetchUserWithEmail(email) else {
        throw LoginError.userNotFound
        }
        return user
    }
    
    private func verifyPassword() throws {
        let stored = try credentialRepository.getPassword(for: email)
        guard password == stored else {
            throw LoginError.invalidCredentials
        }
    }
    
    private func completeLogin(with user: User) {
        Task {
            await session.login(with: user)
        }
    }
    
    func handle(error: Error) {
        switch error {
            
        case let err as LoginError:
          showAlert(title: "Login Error", message: err.errorDescription)
            
        case let err as KeychainHelperError:
          showAlert(title: "Keychain Error", message: err.messageError)
            
        default:
          showAlert(title: "Unknown Error", message: error.localizedDescription)
            
        }
    }

    private func showAlert(title: String, message: String) {
        alertTitle   = title
        alertMessage = message
        showAlert    = true
    }
}

enum LoginError: LocalizedError {
  case userNotFound, invalidCredentials

  var errorDescription: String {
      switch self {
      case .userNotFound:
          return "User not found"
      case .invalidCredentials:
          return "Email or password is incorrect"
      }
    }
}


