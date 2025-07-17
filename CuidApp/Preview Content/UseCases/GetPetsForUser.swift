//
//  GetPetsForUser.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import Foundation

struct GetPetsForUser {
    let repository: PetRepository
    
    func execute(userId: UUID) async -> [Pet] {
        await repository.fetchPetsWith(ownerId: userId)
    }
}
