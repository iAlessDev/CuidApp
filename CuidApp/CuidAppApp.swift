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
    var body: some Scene {
        WindowGroup {
            PetsView(viewModel: HomePetsViewModel())
        }
    }
}

