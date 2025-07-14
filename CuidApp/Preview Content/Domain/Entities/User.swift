//
//  User.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import Foundation
import SwiftUI

struct User: ToSwiftDataUserProtocol {
    
    var id: UUID
    var name: String
    var email: String
    var birthDate: Date
    var pets: [Pet] = []
    var profileImage: Data?

    init(id: UUID, name: String, email: String, birthDate: Date, pets: [Pet], profileImage: Data?) {
        self.id = id
        self.name = name
        self.email = email
        self.birthDate = birthDate
        self.pets = pets
        self.profileImage = profileImage
    }
    
    func toSwiftDataUser() -> SwiftDataUser {
        let swiftDataUser =
            SwiftDataUser(
                id: id,
                name: name,
                email: email,
                birthDate: birthDate,
                pets: pets.map{ $0.toSwiftDataPet() },
                profileImage: profileImage
            )
        return swiftDataUser
    }
}
