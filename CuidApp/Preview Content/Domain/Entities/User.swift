//
//  User.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import Foundation
import SwiftUI

struct User {
    var id: UUID
    var name: String
    var email: String
    var birthDate: Date
    var pets: [Pet] = []
    var profileImage: UIImage?

    init(id: UUID, name: String, email: String, birthDate: Date, pets: [Pet], profileImage: UIImage?) {
        self.id = id
        self.name = name
        self.email = email
        self.birthDate = birthDate
        self.pets = pets
        self.profileImage = profileImage
    }
}
