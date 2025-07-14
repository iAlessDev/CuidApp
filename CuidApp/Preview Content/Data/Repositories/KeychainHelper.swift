//
//  CredentialsRepository.swift
//  CuidApp
//
//  Created by Paul Flores on 11/07/25.
//

import Foundation
import Security

class KeychainHelper: CredentialsRepositoryProtocol {
    private let service = "com.iAlessDev.CuidApp"
    static let shared = KeychainHelper()
    
    func savePassword(_ password: String, for email: String) throws -> Bool {
        
        guard let dataPassword = password.data(using: .utf8) else { return false }
        
        // Luego lo guardamos
        let attributes = [
            // Generic password will be saved
            kSecClass: kSecClassGenericPassword,
            // App identifier
            kSecAttrService: service,
            // User identifier
            kSecAttrAccount: email,
            // Passowrd value
            kSecValueData: dataPassword,
            // Only accessibly with unlocked device
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ] as CFDictionary

        // Save data to keychain
        let status = SecItemAdd(attributes, nil)
        
        if status == errSecDuplicateItem {
            throw KeychainHelperError.duplicatePassword
            } else if status != errSecSuccess {
                throw KeychainHelperError.unableToAddPassword
            } else {
                return true
            }
    }
    
    func getPassword(for email: String) throws -> String? {
        // 1. Construir el query que identifica el ítem en el Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // Return to GenericPassword
            kSecAttrService as String: service,            // app identifier
            kSecAttrAccount as String: email,              // Password email
            kSecReturnData as String: true,               // Return data
            kSecMatchLimit as String: kSecMatchLimitOne   // Only single result
        ]
        
        // 2. Execute search
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        // 3. Manage return codes
        switch status {
        case errSecSuccess:
            
            guard
                let data = result as? Data,
                let password = String(data: data, encoding: .utf8)
            else {
                throw KeychainHelperError.unableToReadPassword
            }
            return password
            
        case errSecItemNotFound:
            // Doesn´t exist a password for this email
            throw KeychainHelperError.passwordNotFound
            
        default:
            // Cualquier otro error del sistema Keychain
            throw KeychainHelperError.unableToReadPassword
        }
    }
}

enum KeychainHelperError: LocalizedError {
    case duplicatePassword, unableToAddPassword, unableToUpdatePassword, unableToDeletePassword, unableToReadPassword, passwordNotFound
    
    var messageError: String {
        switch self {
        case .duplicatePassword:
            return "Duplicate password"
        case .unableToAddPassword:
            return "Unable to add password"
        case .unableToUpdatePassword:
            return "Unable to update password"
        case .unableToDeletePassword:
            return "Unable to delete password"
        case .unableToReadPassword:
            return "Unable to read password"
        case .passwordNotFound:
            return "Password not found"
        }
    }
}
