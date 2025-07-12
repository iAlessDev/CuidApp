//
//  PasswordStrengthBarView.swift
//  CuidApp
//
//  Created by Paul Flores on 09/07/25.
//

import SwiftUI

import SwiftUI

enum PasswordSecurityLevel {
    case weak, medium, strong
    
    // Color asociado
    var color: Color {
        switch self {
        case .weak:   return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }
    
    // Cuántos segmentos se llenan (1, 2 o 3)
    var filledSegments: Int {
        switch self {
        case .weak:   return 1
        case .medium: return 2
        case .strong: return 3
        }
    }
}

struct PasswordStrengthBarView: View {
    let strength: PasswordSecurityLevel
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(segmentColor(at: index))
            }
        }
        .cornerRadius(2.5)
        .padding(.horizontal)
    }
    
    private func segmentColor(at index: Int) -> Color {
        return index < strength.filledSegments
            ? strength.color
            : Color.gray.opacity(0.3)
    }
}


#Preview {
    PasswordStrengthBarView(strength: PasswordSecurityLevel.medium)
}
