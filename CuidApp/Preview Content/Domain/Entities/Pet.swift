//
//  Dog.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import Foundation
import SwiftUI

struct Pet: Identifiable, Hashable {
    let id: UUID
    let ownerId: UUID
    let animal: String
    let name: String
    let birthDate: Date
    let isAlive: Bool
    let image: Data?
    let breed: String
    
    init(id: UUID, ownerId: UUID, animal: String, name: String, birthDate: Date, isAlive: Bool, image: Data?, breed: String) {
        self.id = id
        self.ownerId = ownerId
        self.animal = animal
        self.name = name
        self.birthDate = birthDate
        self.isAlive = isAlive
        self.image = image
        self.breed = breed
    }
    
    func toSwiftDataPet() -> SwiftDataPet {
        let swiftDataPets =
            SwiftDataPet(
                id: id,
                ownerId: ownerId,
                animal: animal,
                name: name,
                birthDate: birthDate,
                isAlive: isAlive,
                image: image,
                breed: breed
            )
        return swiftDataPets
    }
}
