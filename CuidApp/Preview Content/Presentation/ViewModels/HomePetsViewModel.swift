//
//  PetsViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import Foundation
import SwiftUI

class HomePetsViewModel: ObservableObject {
    @Published var pet: Pet
    @Published var user: User
    @Published var hasProfileImage: Bool
    
    init(pet: Pet, user: User) {
        self.pet = pet
        self.user = user
        self.hasProfileImage = user.profileImage != nil ? true : false
    }
    
    func dataImageToUUImage(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
