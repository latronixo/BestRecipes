//
//  IngredientsView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import SwiftUI

// MARK: - Ingredients View
struct IngredientsView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header
            Text("Ingredients")
                .font(.poppinsSemibold(size: 20))
                .foregroundColor(.black)
            
            // MARK: - Ingredients List
            VStack(spacing: 12) {
                ForEach(Array(viewModel.recipe.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                    IngredientRow(
                        ingredient: ingredient,
                        index: index,
                        viewModel: viewModel
                    )
                }
                
                // MARK: - Add Ingredient Button
                Button(action: {
                    viewModel.addIngredient()
                }) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Add ingredient")
                            .font(.poppinsRegular(size: 16))
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        IngredientsView(viewModel: AddRecipeViewModel())
        
        Spacer()
    }
    .padding()
}
