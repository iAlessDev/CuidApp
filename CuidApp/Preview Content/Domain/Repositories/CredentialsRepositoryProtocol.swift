//
//  CredentialsRepositoryProtocol.swift
//  CuidApp
//
//  Created by Paul Flores on 11/07/25.
//

import Foundation

protocol CredentialsRepositoryProtocol {
    func savePassword(_ password: String, for email: String) throws -> Bool
    func getPassword(for email: String) throws -> String?
}
