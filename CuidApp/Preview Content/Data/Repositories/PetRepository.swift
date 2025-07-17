//
//  DatabaseService.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import Foundation
import SwiftData

class PetRepository: PetRepositoryProtocol {
    
    private let container: ModelContainer
    private let context: ModelContext
    
    init() {
        self.container = try! ModelContainer(
            for: SwiftDataPet.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.context = ModelContext(container)
    }
    
    func savePet(_ pet: Pet) async -> Bool {
        let swiftDataPet = pet.toSwiftDataPet()
        
        do {
            context.insert(swiftDataPet)
            try context.save()
            return true
        } catch {
            return error.localizedDescription.contains("already exists")
        }
    }
    
    func fetchPetsWith(ownerId: UUID) async -> [Pet] {
        let predicate =
        #Predicate<SwiftDataPet> { register in register.ownerId == ownerId }
        
        let descriptor = FetchDescriptor<SwiftDataPet>(predicate: predicate)
        
        do {
            let swiftDataPet = try context.fetch(descriptor)
            print(swiftDataPet.first?.toPet() ?? "No Pets")
            return swiftDataPet.map { $0.toPet() }
        } catch {
            print("Unable to fetch user")
            return []
        }
    }
    
    func deletePet(withId id: UUID) async -> Bool {
        return true
    }

}
