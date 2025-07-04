//
//  DatabaseService.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import Foundation
import SwiftData

@MainActor
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
        return true
    }
    
    func getPets(for ownerId: UUID) async -> [Pet] {
        return []
    }
    
    func deletePet(withId id: UUID) async -> Bool {
        return true
    }

}
