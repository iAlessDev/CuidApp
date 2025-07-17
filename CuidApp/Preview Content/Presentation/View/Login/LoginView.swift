//
//  LoginView.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import SwiftUI

struct LoginView: View {
    @State private var transitionToSignUpId: String = "id"
    @ObservedObject var viewModel: LoginViewModel
    
    let zoomNamespace: Namespace.ID
    
    
    var body: some View {
        NavigationStack {
            VStack {
                // HEADER
                header
                // Login Textfields
                login
                signUp
                Spacer()
                // Footer
                footer
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Cuida App")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    
    var header: some View {
        VStack {
            Image(systemName: "pawprint.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
        }
        .padding(.top, 50)
    }
    
    var login: some View {
        VStack(alignment: .center, spacing: 24) {
            
            HStack {
                Image(systemName: "envelope")
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.separator), lineWidth: 1)
            }
            
            
            HStack {
                Image(systemName: "key")
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.separator), lineWidth: 1)
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.signIn()
                    } catch {
                        viewModel.handle(error: error)
                    }
                }
            } label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
            .controlSize(.large)
        }
        .padding(.horizontal)
        .padding(.top)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("Accept"))
            )
        }
    }
    
    
    var signUp: some View {
        VStack(spacing: 15) {
            Text("Don't have an account?")
            
            NavigationLink {
                SignUpView(photoPickerViewModel: PhotoPickerViewModel())
                    .navigationTransition(
                        // The end of the transition, where will end
                        .zoom(
                            sourceID: "login-signup",
                            in: zoomNamespace
                        )
                    )
            } label: {
                Text("Create an account")
            }
            .tint(.secondary)
            .controlSize(.regular)
            .matchedTransitionSource(id: "login-signup", in: zoomNamespace)
        }
        .padding(.top, 30)
    }
    
    var footer: some View {
        Text("Cada cuidado que das, vuelve en forma de amor.")
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .font(.body)
            .frame(maxWidth: 250)
    }
    
}

#Preview {
    @Previewable @Namespace var zoomNameSpace
    LoginView(
        viewModel: LoginViewModel(session: SessionManager()),
        zoomNamespace: zoomNameSpace
    )
}
