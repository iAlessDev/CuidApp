//
//  UserRepositoryProtocol.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func saveUser(_ user: User) async -> Bool
    func getUser() async -> User?
    func deleteUser() async -> Bool
}
