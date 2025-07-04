//
//  PetsView.swift
//  CuidApp
//
//  Created by Paul Flores on 02/07/25.
//

import SwiftUI
import SwiftData

struct PetsView: View {
    @StateObject var viewModel: HomePetsViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PetsView(viewModel: HomePetsViewModel())
}
