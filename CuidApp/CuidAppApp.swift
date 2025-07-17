///
///  CuidAppApp.swift
///  CuidApp
///
///  Created by Paul Flores on 02/07/25.
///  Optimazed version with dependency inyection and clean navigation
///
import SwiftUI
import SwiftData

@main
struct CuidAppApp: App {
    // MARK: - Repositorios compartidos
    private let userRepository = UserRepository()

    // MARK: - Gestor de sesión
    @StateObject private var session: SessionManager

    // MARK: - Namespace para transiciones
    @Namespace private var zoomNamespace

    // MARK: - Inicialización
    init() {
        // Configuración global de la UITabBar
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.secondarySystemGroupedBackground
            .withAlphaComponent(0.35)
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.2)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

        // Inyección de dependencias evitando captura de self en autoclosure
        let repo = userRepository
        _session = StateObject(wrappedValue: SessionManager(userRepository: repo))
    }

    // MARK: - Escena principal
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Si no está logueado, mostramos LoginView
                if !session.isLoggedIn {
                    LoginView(
                        viewModel: LoginViewModel(session: session),
                        zoomNamespace: zoomNamespace
                    )

                // Si está logueado pero sin usuario cargado, mostrar loader
                } else if session.currentUser == nil {
                    ProgressView("Cargando usuario...")
                        .environmentObject(session)

                // Una vez cargado el usuario, presentar HomePetsView
                } else {
                    MainTabView(user: session.currentUser!)
                        .environmentObject(session)
                }
            }
        }
    }
}
