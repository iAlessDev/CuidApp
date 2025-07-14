//
//  UserRepository.swift
//  CuidApp
//
//  Created by Paul Flores on 10/07/25.
//

import Foundation
import SwiftData

class UserRepository: UserRepositoryProtocol {
    
    private let container: ModelContainer
    private let context: ModelContext
    
    init() {
        
        self.container = try! ModelContainer(
            for: SwiftDataUser.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        
        self.context = ModelContext(container)
    }
    
    func saveUser(_ user: User, password: String) async throws -> Bool {
        let swiftDataUser = user.toSwiftDataUser()
        
        do {
            context.insert(swiftDataUser)
            try context.save()
            return true
        } catch {
            return error.localizedDescription.contains("already exists")
        }
    }
    
    func fetchUserWithEmail(_ email: String) async throws -> User? {
        let predicate =
        #Predicate<SwiftDataUser> { register in register.email == email }
        
        let descriptor = FetchDescriptor<SwiftDataUser>(predicate: predicate)
        
        do {
            let swiftDataUser = try context.fetch(descriptor)
            print(swiftDataUser.first?.toUser() ?? "No user")
            return swiftDataUser.first?.toUser()
        } catch {
            print("Unable to fetch user")
            return nil
        }
    }
    
    func deleteUser() async -> Bool {
        return true
    }
}
