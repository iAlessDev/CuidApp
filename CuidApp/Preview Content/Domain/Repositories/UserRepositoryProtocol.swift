//
//  UserRepositoryProtocol.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func saveUser(_ user: User, password: String) async throws -> Bool
    func fetchUserWithEmail(_ email: String) async throws -> User? 
    func deleteUser() async -> Bool
}
