//
//  IngredientRow.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//


import SwiftUI

struct IngredientRow: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    
    let index: Int
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12) {
            // MARK: - Item Name Field
            TextField("Item name", text: Binding(
                get: {
                    guard index < (viewModel.recipe.extendedIngredients?.count ?? 0) else { return ""}
                    return viewModel.recipe.extendedIngredients?[index].name ?? ""
                },
                set: { viewModel.updateIngredientName(at: index, name: $0) }
            ))
            .font(.poppinsRegular(size: 16))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
            )
            
            // MARK: - Quantity Field
            TextField("Quantity", text: Binding(
                get: {
                    guard index < (viewModel.recipe.extendedIngredients?.count ?? 0) else { return "" }
                    return String(format: "%.1f", viewModel.recipe.extendedIngredients?[index].amount ?? 0.0)
                },
                set: { viewModel.updateIngredientQuantity(at: index, quantity: $0) }
            ))
            .font(.poppinsRegular(size: 16))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
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
            viewModel: AddRecipeViewModel(),
            index: 0
        )
        
        IngredientRow(
            viewModel: AddRecipeViewModel(),
            index: 1
        )
    }
    .padding()
    .background(Color(.systemBackground))
}
