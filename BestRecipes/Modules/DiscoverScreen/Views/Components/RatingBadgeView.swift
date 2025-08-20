//
//  RatingBadgeView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 20.08.2025.
//

import SwiftUI

struct RatingBadgeView: View {
    let rating: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 12, weight: .semibold))
            
            Text(rating)
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.12))
                )
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    RatingBadgeView(rating: "4.87")
}
