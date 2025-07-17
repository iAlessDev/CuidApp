//
//  PetRepository.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import Foundation

protocol PetRepositoryProtocol {
    func savePet(_ pet: Pet) async -> Bool
    func fetchPetsWith(ownerId: UUID) async -> [Pet]
    func deletePet(withId id: UUID) async -> Bool
}
