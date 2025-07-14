//
//  PetsView.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import SwiftUI
import SwiftData

struct HomePetsView: View {
    @StateObject var viewModel: HomePetsViewModel
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                header
                
                if let pet = viewModel.user.pets.first {
                    PetCardView(petCardViewModel: PetCardViewModel(pet: pet))
                }
                tasks
                announce
                
                Button {
                    session.logout()
                } label: {
                    Text("Logout")
                }
            }
            .background(Color(red: 0.98, green: 0.94, blue: 0.89))
        }
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello \(viewModel.user.name)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("\(viewModel.user.pets.first?.name ?? "Empty pet") is waiting for you")
                        .font(.title2)
                }
                Spacer()
                if let profileImage = viewModel.user.profileImage {
                    Image(uiImage: UIImage(data: profileImage)!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.blue)
                }
            }
            .padding()
        }
    }
    
    var tasks: some View {
        VStack {
            
            HStack {
                Text("Future Tasks")
                    .font(.title3.weight(.medium))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            VStack {
                HStack {
                    Text("🚿 Shower at 5:00 Pm")
                        .font(.body.weight(.medium))
                    
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.blue)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(25)
            .background(Color(red: 1.0, green: 0.98, blue: 0.95))
            .cornerRadius(16)
            .shadow(radius: 2)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
    }
    
    var announce: some View {
        VStack {
            
            HStack {
                Text("Hey! look at me")
                    .font(.title3.weight(.medium))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            VStack {
                HStack {
                    Text("Pancho is Happy!, He Run 1 km today")
                        .font(.title3)
                        .padding(10)
                        .cornerRadius(12)
                    
                    Image(systemName: "pawprint.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.orange)



                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .padding(25)
            .background(Color(red: 1.0, green: 0.98, blue: 0.95))
            .cornerRadius(16)
            .shadow(radius: 2)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
        

    }
}

#Preview {
    let dateComponents = DateComponents(
        year: 2000,
        month: 5,
        day: 20
    )
    
    let pet = Pet(id: UUID(), ownerId: UUID(), animal: "Dog", name: "Pancho", birthDate: Calendar.current.date(from: dateComponents)!, isAlive: true, image: nil, breed: "Chihuaua")
    
    let user = User(id: UUID(), name: "iAlessDev", email: "paul@mail.com", birthDate: NSDate() as Date, pets: [pet], profileImage: nil)
    
    HomePetsView(viewModel: HomePetsViewModel(user: user))
        .environmentObject(SessionManager())
}


