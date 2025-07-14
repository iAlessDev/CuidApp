//
//  LoginView.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import SwiftUI

struct LoginView: View {
    @State private var transitionToSignUpId: String = "id"
    @StateObject var viewModel: LoginViewModel
    
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
            .background(Color.cuidaAppBg)
        }
    }
        
    
    var header: some View {
        VStack {
            Text("CuidaApp")
                .font(.largeTitle)
            Image(systemName: "pawprint.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
        }
        .padding(.top, 50)
    }
    
    var login: some View {
        VStack(alignment: .center, spacing: 25) {
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.orange)

                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
            }
            .padding(20)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 2)
            )
            .cornerRadius(10)

            
            HStack {
                Image(systemName: "key")
                    .foregroundColor(.orange)

                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
            }
            .padding(20)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 2)
            )
            .cornerRadius(10)
            
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
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(Color.cuidaAppBgButtons)
                    .clipShape(.rect(cornerRadius: 20))
                    
            }
        }
        .padding(.top, 50)
        .padding(.horizontal)
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
                            SignUpView(
                                viewModel: SignUpViewModel(),
                                photoPickerViewModel: PhotoPickerViewModel()
                            )
                            .navigationTransition(
                                // The end of the transition, where will end
                                .zoom(
                                    sourceID: "login-signup",
                                    in: zoomNamespace
                                )
                            )
                        } label: {
                            Text("Create an account")
                                .foregroundStyle(Color.orange)
                        }
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
        
extension Color {
  static let cuidaAppBg = Color(red: 1, green: 0.98, blue: 0.95)
  static let cuidaAppBgButtons = Color(red: 1.0, green: 0.58, blue: 0.20)
}

#Preview {
    @Previewable @Namespace var zoomNameSpace
    LoginView(
        viewModel: LoginViewModel(session: SessionManager()),
        zoomNamespace: zoomNameSpace
    )
}
