//
//  SessionManager.swift
//  CuidApp
//
//  Created by Paul Flores on 12/07/25.
//

import Foundation

@MainActor
class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    
    private let isLoggedInKey = "isLoggedIn"
    private let userEmailKey = "loggedUserEmail"
    private let userRepository: UserRepositoryProtocol
    
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
        self.isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
        
        if isLoggedIn {
            Task {
                await loadPersistedUser()
            }
        }
    }
    
    func login(with user: User) {
        currentUser = user
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
        UserDefaults.standard.set(user.email, forKey: userEmailKey)
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: isLoggedInKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
    }
    
    func loadPersistedUser() async {
        guard let email = UserDefaults.standard.string(forKey: userEmailKey) else {
            self.isLoggedIn = false
            return
        }

        
        do {
            let user = try await userRepository.fetchUserWithEmail(email)
            self.currentUser = user
        } catch {
            self.isLoggedIn = false
            self.currentUser = nil
        }
    }
}
