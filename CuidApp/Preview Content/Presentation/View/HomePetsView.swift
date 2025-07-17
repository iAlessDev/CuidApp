//
//  PetsView.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import SwiftUI
import SwiftData

struct HomePetsView: View {
    @State var isShowingAddPetModal: Bool = false
    @StateObject var viewModel: HomePetsViewModel
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
                VStack {
                    header

                    if let pet = viewModel.user.pets.first {
                        ScrollView {
                            PetCardView(petCardViewModel: PetCardViewModel(pet: pet))
                            tasks
                            announce
                        }
                    } else {
                        VStack {
                            Spacer()
                            Image(systemName: "dog")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.secondary.opacity(0.5))
                            Text("Add a new pet to get started")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                                .foregroundStyle(.secondary.opacity(0.5))
                            Button {
                                isShowingAddPetModal = true
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .imageScale(.large)
                                    .frame(width: 44, height: 44)
                                    .contentShape(Rectangle())
                                    .accessibilityLabel("Agregar mascota")
                            }
                            Spacer()
                        }
                    }

                    Button {
                        session.logout()
                    } label: {
                        Text("Logout")
                    }
                    .padding(.top, 20)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $isShowingAddPetModal) {
            AddPetSheetView(
                viewModel: AddPetSheetViewModel(user: session.currentUser!),
                photoPickerViewModel: PhotoPickerViewModel()
            )
        }
    }

    
    var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello \(viewModel.user.name)")
                        .lineLimit(1)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    if let pet = viewModel.user.pets.first {
                        Text("\(pet) is waiting for you")
                    }
                }
                Spacer()
                if let profileImage = viewModel.user.profileImage {
                    Image(uiImage: UIImage(data: profileImage)!)
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFill()
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
    
    let user = User(id: UUID(), name: "iAlessDev", email: "paul@mail.com", birthDate: NSDate() as Date, pets: [], profileImage: nil)
    
    HomePetsView(viewModel: HomePetsViewModel(user: user))
        .environmentObject(SessionManager())
}


