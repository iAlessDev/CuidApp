//
//  CuidAppApp.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//
import SwiftUI
import SwiftData

@main
struct CuidAppApp: App {
    let pet = Pet(id: UUID(), ownerId: UUID(), animal: "Dog", name: "Pancho", birthDate: NSDate() as Date, isAlive: true, image: nil, breed: "Chihuaua")
    @Namespace private var zoomNameSpace
    
    init() {
        let appearance = UITabBarAppearance()
        // 1. Fondo difuminado base
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        // 2. Tinte consistente con HIG:
        //    usamos secondarySystemGroupedBackground (un gris suave)
        //    al 30–40% de opacidad para distinguirla del fondo principal
        appearance.backgroundColor = UIColor.secondarySystemGroupedBackground.withAlphaComponent(0.35)
        
        // 3. Línea suave de separación
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.2)

        // 4. Aplicación global
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView(zoomNamespace: zoomNameSpace)
            }
        }
    }
}

