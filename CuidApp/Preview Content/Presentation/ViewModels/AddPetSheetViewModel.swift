//
//  AddPetSheetViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 14/07/25.
//

import Foundation

class AddPetSheetViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var breed: String = ""
    @Published var type: String = ""
    @Published var birthDate: Date = Date()
    @Published var isAlive: Bool = true
    @Published var image: Data?
    @Published var shouldReturnToHomePet = false
    
    var alertMessage: String = ""
    var alertTitle: String = ""
    @Published var showAlert: Bool = false
    
    var user: User
    private let petRepository: PetRepositoryProtocol
    
    init(user: User, petRepository: PetRepositoryProtocol = PetRepository()) {
        self.user = user
        self.petRepository = petRepository
    }
    
    func fetchUserPets() async -> [Pet]{
        let pets = await petRepository.fetchPetsWith(ownerId: user.id)
        print("Saved pets for: \(user.name) \n \(pets)")
        return pets
    }
    
    @MainActor
    func addPet() async throws {
        do {
            try validateFields()
            let newPet = makeNewPet()
            let success = try await savePet(newPet)
            finishRegistration(success: success)
        } catch let error as AddPetShetError {
            presentAlert(title: "Validation Error", message: error.errorDescription)
        }
    }
    
    func validateFields() throws {
        try validateName()
        try validateBreed()
        try validateAnimal()
    }
    
    func makeNewPet() -> Pet {
        Pet(
            id: UUID(),
            ownerId: user.id,
            animal: type,
            name: name,
            birthDate: birthDate,
            isAlive: true,
            image: image,
            breed: breed
        )
    }
    
    func savePet(_ pet: Pet) async throws -> Bool {
        return await petRepository.savePet(pet)
    }
    
    func validateAnimal() throws {
        guard !type.isEmpty else { throw AddPetShetError.emptyAnimal }
    }
    
    func validateName() throws {
        guard !name.isEmpty else { throw AddPetShetError.emptyName }
    }
    
    func validateBreed() throws {
        guard !breed.isEmpty else { throw AddPetShetError.emptyBreed }
    }
    
    
    private func finishRegistration(success: Bool) {
        let title   = success ? "Success" : "Error"
        let message = success
            ? "Registration complete!"
            : "An error occurred while registering."
        presentAlert(title: title, message: message)
        shouldReturnToHomePet = success
    }
    
    private func presentAlert(title: String, message: String) {
        alertTitle   = title
        alertMessage = message
        showAlert    = true
    }
    
    enum AddPetShetError: LocalizedError {
        case emptyAnimal, emptyName, emptyBreed
        
        var errorDescription: String {
            switch self {
            case .emptyName: return "Add a new name to your pet 🐶"
            case .emptyBreed: return "Tell us about your pet breed 🦮"
            case .emptyAnimal: return "We need to know what kind of animal you want to add 👀"
            }
        }
    }
    
}
