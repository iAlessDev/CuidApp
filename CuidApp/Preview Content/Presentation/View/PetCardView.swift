//
//  PetCardView.swift
//  CuidApp
//
//  Created by Paul Flores on 07/07/25.
//

import SwiftUI

struct PetCardView: View {
    let petCardViewModel: PetCardViewModel
    
    var body: some View {
        VStack {
            HStack {
                if let image = petCardViewModel.pet.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .padding()
                } else {
                    Image(systemName: "pawprint.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.tint)
                        .padding(24)
                }
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(petCardViewModel.pet.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Age: \(petCardViewModel.petAge()) years old")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.blue)
                    .padding(.all, 10)
                    .background(.thinMaterial)
                    .clipShape(.circle)
            }
            
            HStack() {
                Spacer()
                Button {
                    print("See details Button")
                } label: {
                    Text("See Details")
                        .foregroundStyle(Color.blue)
                }
            }
        }
        .padding()
        .background(Color(red: 1.0, green: 0.98, blue: 0.95))
        .cornerRadius(16)
        .shadow(radius: 2)
        .padding(.horizontal, 20)
    }
}

#Preview {
    let dateComponents = DateComponents(
        year: 2000,
        month: 5,
        day: 20
    )
    
    let pet = Pet(id: UUID(), ownerId: UUID(), animal: "Dog", name: "Pancho", birthDate: Calendar.current.date(from: dateComponents)!, isAlive: true, image: nil, breed: "Chihuaua")
    
    PetCardView(petCardViewModel: PetCardViewModel(pet: pet))
}
