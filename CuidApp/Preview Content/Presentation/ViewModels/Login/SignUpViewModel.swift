//
//  RegisterViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var passwordSecurityLevel: passwordSecurityLevel?
    
    init() {
        
    }
    
    
}

enum passwordSecurityLevel {
    case weak, medium, strong
}

