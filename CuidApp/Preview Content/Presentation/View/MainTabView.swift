//
//  MainTabView.swift
//  CuidApp
//
//  Created by Paul Flores on 07/07/25.
//

import SwiftUI

struct MainTabView: View {
    // Estado para la pestaña seleccionada
    @State private var selection: Tab = .home
    @EnvironmentObject var session: SessionManager
    @State var user: User
    
    // Definimos un enum para las pestañas
    enum Tab {
        case home, pets, profile
    }

    var body: some View {
        TabView(selection: $selection) {
            // 1. Home
            HomePetsView(viewModel: HomePetsViewModel(user: user))
                .tabItem {
                    Label("Home", systemImage: selection == .home ? "house.fill" : "house")
                }
                .tag(Tab.home)

            // 3. Mascotas
            PetsView()
                .tabItem {
                    Label("Pets", systemImage: selection == .pets ? "pawprint.circle.fill" : "pawprint.circle")
                }
                .tag(Tab.pets)

            // 4. Perfil
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selection == .profile ? "person.crop.circle.fill" : "person.crop.circle")
                }
                .tag(Tab.profile)
        }
        .accentColor(.blue)
        .toolbarBackground(Color(.secondarySystemBackground), for: .tabBar)
        .toolbarBackground(.visible,                       for: .tabBar)
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
    
    MainTabView(user: user)
        .environmentObject(HomePetsViewModel(user: user))
}
