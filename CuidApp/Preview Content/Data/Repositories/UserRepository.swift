//
//  UserRepository.swift
//  CuidApp
//
//  Created by Paul Flores on 10/07/25.
//

import Foundation

class UserRepository: UserRepositoryProtocol {
    func saveUser(_ user: User) async -> Bool {
        return true
    }
    
    func getUser() async -> User? {
        return Optional.none
    }
    
    func deleteUser() async -> Bool {
        return true
    }
}
