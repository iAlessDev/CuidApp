//
//  Dog.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import Foundation

struct Pet: Identifiable, Hashable {
    let id: UUID
    let ownerId: UUID
    let animal: String
    let name: String
    let birthDate: Date
    let isAlive: Bool
    let image: Data?
    let breed: String
    
}
