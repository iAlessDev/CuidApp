//
//  SwiftDataPet.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import SwiftData
import SwiftUI
import Foundation

@Model
class SwiftDataPet {
    var id: UUID
    var ownerId: UUID
    var animal: String
    var name: String
    var birthDate: Date
    var isAlive: Bool
    var image: Data?
    var breed: String
    
    init(id: UUID, ownerId: UUID, animal: String, name: String, birthDate: Date, isAlive: Bool, image: Data? = nil, breed: String) {
        self.id = id
        self.ownerId = ownerId
        self.animal = animal
        self.name = name
        self.birthDate = birthDate
        self.isAlive = isAlive
        self.image = image
        self.breed = breed
    }
}

extension SwiftDataPet: ToPetProtocol {
    func toPet() -> Pet {
        return Pet(
            id: id,
            ownerId: ownerId,
            animal: animal,
            name: name,
            birthDate: birthDate,
            isAlive: isAlive,
            image: image,
            breed: breed
        )
    }
}
