//
//  AddPetSheetView.swift
//  CuidApp
//
//  Created by Paul Flores on 14/07/25.
//

import SwiftUI

struct AddPetSheetView: View {
    @StateObject var viewModel: AddPetSheetViewModel
    @ObservedObject var photoPickerViewModel: PhotoPickerViewModel
    
    
    var body: some View {
        NavigationStack {
            form
                .navigationTitle("New Pet")
                .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage), dismissButton: .default(Text("Accept")))
        }
    }
    
    var form: some View {
        Form {
            header
            petInformation
            button
        }
        .formStyle(GroupedFormStyle())
    }
    
    var header: some View {
        Section {
            HStack {
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    Button {
                        photoPickerViewModel.requestGalleryAccess()
                    } label: {
                        if let profileImage = photoPickerViewModel.image {
                            Image(uiImage: profileImage)
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                        } else {
                            Circle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(width: 110, height: 110)
                                .overlay(
                                    Image(systemName: "dog.fill")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.secondary)
                                )
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Add pet image")
                    .photosPicker(
                        isPresented: $photoPickerViewModel.showPhotoPicker,
                        selection: $photoPickerViewModel.selectedPhoto,
                        matching: .images
                    )
                    .onChange(of: photoPickerViewModel.image) {
                        viewModel.image = photoPickerViewModel.selectedImageData
                    }
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .symbolRenderingMode(.multicolor)
                        .offset(x: -2, y: -4)
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
    }
    
    var petInformation: some View {
        Section("Pet information") {
            TextField("Name", text: $viewModel.name)
            TextField("Breed", text: $viewModel.breed)
            TextField("Type", text: $viewModel.type)
            DatePicker("Birthdate", selection: $viewModel.birthDate, in: ...Date(), displayedComponents: .date)
        }
    }
    
    var button: some View {
        Section {
            Button {
                Task {
                    try await viewModel.addPet()
                }
            } label: {
                Text("Add me!")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .controlSize(.large)
            
            /*
             Debuggin Button
             Button {
                Task {
                    await viewModel.fetchUserPets()
                }
            } label: {
                Text("Show my pets")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .controlSize(.large)
             */
        }
        .listRowBackground(Color.clear)
    }

}

#Preview {
    let user = User(id: UUID(), name: "iAlessDev", email: "paul@mail.com", birthDate: NSDate() as Date, pets: [], profileImage: nil)
    
    AddPetSheetView(
        viewModel: AddPetSheetViewModel(user: user),
        photoPickerViewModel: PhotoPickerViewModel()
    )
    .environmentObject(PhotoPickerViewModel())
    
}
