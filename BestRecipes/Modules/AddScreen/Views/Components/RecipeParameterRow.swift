//
//  RecipeParameterRow.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//


import SwiftUI

struct RecipeParameterRow: View {
    
    // MARK: - Properties
    let icon: String
    let title: String
    let value: String
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // MARK: - Icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .frame(width: 24)
                
                // MARK: - Title
                Text(title)
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                // MARK: - Value
                Text(value)
                    .font(.poppinsSemibold(size: 16))
                    .foregroundColor(.black)
                
                // MARK: - Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        RecipeParameterRow(
            icon: "person.2.fill",
            title: "Serves",
            value: "04",
            action: {}
        )
        
        RecipeParameterRow(
            icon: "clock.fill",
            title: "Cook Time",
            value: "20 min",
            action: {}
        )
    }
    .padding()
    .background(Color(.systemBackground))
}