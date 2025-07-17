import SwiftUI
import PhotosUI

struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel = SignUpViewModel()
    @ObservedObject var photoPickerViewModel: PhotoPickerViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Main Body
    var body: some View {
        NavigationStack {
            form
                .navigationTitle("Sign Up")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
var form: some View {
    Form {
        header
        registrationFields
        button
    }
    .formStyle(GroupedFormStyle())
}

    // MARK: - Header
    var header: some View {
        Section {
            HStack {
                Spacer()
                ZStack(alignment: .trailing) {
                    Button {
                        photoPickerViewModel.requestGalleryAccess()
                    } label: {
                        if let profileImage = photoPickerViewModel.image {
                            Image(uiImage: profileImage)
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                        } else {
                            Circle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 60))
                                        .foregroundStyle(Color.secondary)
                                }
                        }
                    }
                    .buttonStyle(.plain)
                    .photosPicker(
                        isPresented: $photoPickerViewModel.showPhotoPicker,
                        selection: $photoPickerViewModel.selectedPhoto,
                        matching: .images
                    )
                    .onChange(of: photoPickerViewModel.image) {
                        viewModel.profileImage = photoPickerViewModel.selectedImageData
                    }
                }
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
    }

    // MARK: - Registration Fields
    var registrationFields: some View {
        Section(
            header: Text("User information"),
            footer: HStack {
                Spacer()
                Group {
                    if viewModel.isValidEmail == false {
                        errorMessage(variable: false, message: "Invalid email format")
                    } else if viewModel.isPasswordsMatching == false {
                        errorMessage(variable: false, message: "Passwords don't match")
                    }
                }
                Spacer()
            }
                .padding(.top, 8)
                .padding(.bottom, 0)
        ) {
                // Name
                TextField("Name", text: $viewModel.name)
                
                // Email + error
                TextField("Email", text: $viewModel.email)
                    
            
                // Password + strength
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("Password", text: $viewModel.password)
                    if let strength = viewModel.passwordSecurityLevel {
                        PasswordStrengthBarView(strength: strength)
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                
                // Repeat Password + match error
                SecureField("Repeat Password", text: $viewModel.repeatPassword)
                
                
                DatePicker("Birthdate", selection: $viewModel.birthDate, displayedComponents: .date)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("Accept"), action: {
                    if viewModel.shouldReturnToLogin {
                        dismiss()
                    }
                })
            )
        }
    }
    
    var button: some View {
        Section {
            Button {
                Task {
                    await viewModel.signUp()
                }
            } label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .controlSize(.large)
        }
        .listRowBackground(Color.clear)
    }

    // MARK: - Helpers

    @ViewBuilder
    func errorMessage(variable: Bool?, message: String) -> some View {
        if variable == false {
            HStack(spacing: 4) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.footnote)
                Text(message)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            .padding(.leading, 8)
            .transition(.opacity)
        }
    }
}

#Preview {
    SignUpView(photoPickerViewModel: PhotoPickerViewModel())
}
