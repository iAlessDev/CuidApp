//
//  CredentialsRepository.swift
//  CuidApp
//
//  Created by Paul Flores on 11/07/25.
//

import Foundation
import Security

class CredentialsRepository: CredentialsRepositoryProtocol {
    static let shared = KeychainHelper()
    
    func savePassword(_ password: String, for email: String) throws {
        <#code#>
    }
    
    func getPassword(for email: String) throws -> String? {
        <#code#>
    }
    
}
