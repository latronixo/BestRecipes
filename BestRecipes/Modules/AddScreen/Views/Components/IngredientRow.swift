//
//  IngredientRow.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//


import SwiftUI

struct IngredientRow: View {
    
    // MARK: - Properties
    let ingredient: Ingredient
    let index: Int
    @ObservedObject var viewModel: AddRecipeViewModel
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12) {
            // MARK: - Item Name Field
            TextField("Item name", text: Binding(
                get: { ingredient.name },
                set: { viewModel.updateIngredientName(at: index, name: $0) }
            ))
            .font(.poppinsRegular(size: 16))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
            )
            
            // MARK: - Quantity Field
            TextField("Quantity", text: Binding(
                get: { String(format: "%.1f", ingredient.amount) },
                set: { viewModel.updateIngredientQuantity(at: index, quantity: $0) }
            ))
            .font(.poppinsRegular(size: 16))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
            )
            .frame(width: 80)
            
            // MARK: - Remove Button
            Button(action: {
                viewModel.removeIngredient(at: index)
            }) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        IngredientRow(
            ingredient: Ingredient.createEmpty(),
            index: 0,
            viewModel: AddRecipeViewModel()
        )
        
        IngredientRow(
            ingredient: Ingredient.createEmpty(),
            index: 1,
            viewModel: AddRecipeViewModel()
        )
    }
    .padding()
    .background(Color(.systemBackground))
}