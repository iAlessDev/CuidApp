//
//  PetCardViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 07/07/25.
//

import Foundation
import UIKit

class PetCardViewModel: ObservableObject {
    
    let pet: Pet
    
    init(pet: Pet) {
        self.pet = pet
    }
    
    func petAge() -> Int {
        let differenceFromPetBirthdayToNow = Calendar.current.dateComponents([.year], from: pet.birthDate, to: Date())
        
        return differenceFromPetBirthdayToNow.year!
    }
}
