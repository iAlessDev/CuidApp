import SwiftUI
import PhotosUI

struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel
    @StateObject var photoPickerViewModel: PhotoPickerViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Main Body
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                header
                registrationFields
                Spacer()
            }
            .padding()
        }
        .background(Color.cuidaAppBg)
        .scrollContentBackground(.hidden)
        
    }

    // MARK: - Header
    var header: some View {
        VStack {
            Text("CuidaApp")
                .font(.largeTitle)
            
            Button {
                photoPickerViewModel.requestGalleryAccess()
            } label: {
                if let profileImage = photoPickerViewModel.image {
                    Image(uiImage: profileImage)
                        .resizable()
                        .clipShape(.circle)
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } else {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                }
            }
            .photosPicker(
                isPresented: $photoPickerViewModel.showPhotoPicker,
                selection: $photoPickerViewModel.selectedPhoto,
                matching: .images)
            
            .onChange(of: photoPickerViewModel.image) {
                viewModel.profileImage = photoPickerViewModel.selectedImageData
            }
        }
        .padding(.top, 50)
    }

    // MARK: - Registration Fields
    var registrationFields: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Name
            textField(image: "person", placeholder: "Name", text: $viewModel.name)

            // Email + error
            textField(image: "envelope", placeholder: "Email", text: $viewModel.email)
            errorMessage(variable: viewModel.isValidEmail, message: "Invalid email format")

            // Birthdate
            iconDatePicker(systemIcon: "calendar", selection: $viewModel.birthDate)

            // Password + strength
            secureField(image: "key", placeholder: "Password", text: $viewModel.password)
            if let strength = viewModel.passwordSecurityLevel {
                PasswordStrengthBarView(strength: strength)
            }

            // Repeat Password + match error
            secureField(image: "key", placeholder: "Repeat Password", text: $viewModel.repeatPassword)
            errorMessage(variable: viewModel.isPasswordsMatching, message: "Passwords don't match")

            // Sign Up button
            Button {
                Task {
                    await viewModel.signUp()
                }
            } label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.cuidaAppBgButtons)
                    .cornerRadius(20)
            }
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

    // MARK: - Helpers

    @ViewBuilder
    func textField(image: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: image).foregroundColor(.orange)
            TextField(placeholder, text: text).autocapitalization(.none)
        }
        .cuidaInputStyle()
    }

    @ViewBuilder
    func secureField(image: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: image).foregroundColor(.orange)
            SecureField(placeholder, text: text)
        }
        .cuidaInputStyle()
    }

    @ViewBuilder
    func iconDatePicker(systemIcon: String, selection: Binding<Date>) -> some View {
        HStack {
            Image(systemName: systemIcon).foregroundColor(.orange)
            Spacer()
            DatePicker("Date of Birth", selection: selection, in: ...Date(), displayedComponents: .date)
        }
        .frame(maxWidth: .infinity)
        .cuidaInputStyle()
    }

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

// MARK: - ViewModifier and Extensions

/// Shared style for all input fields
struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 2)
            )
            .cornerRadius(10)
    }
}

extension View {
    /// Applies the shared input-field style
    func cuidaInputStyle() -> some View {
        modifier(InputFieldStyle())
    }
}

#Preview {
    
    return SignUpView(
        viewModel: SignUpViewModel(),
        photoPickerViewModel: PhotoPickerViewModel()
    )
}
