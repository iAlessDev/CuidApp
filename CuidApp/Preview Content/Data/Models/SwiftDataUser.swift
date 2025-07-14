//
//  SwiftDataUser.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class SwiftDataUser: Identifiable {
    var id: UUID
    var name: String
    var email: String
    var birthDate: Date
    var pets: [SwiftDataPet] = []
    var profileImage: Data?
    
    init(id: UUID, name: String, email: String, birthDate: Date, pets: [SwiftDataPet], profileImage: Data? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.birthDate = birthDate
        self.pets = pets
        self.profileImage = profileImage
    }
}

extension SwiftDataUser: ToUserProtocol {
    func toUser() -> User {
        return User(
            id: id,
            name: name,
            email: email,
            birthDate: birthDate,
            pets: pets.map { $0.toPet() },
            profileImage: profileImage
        )
    }
}
