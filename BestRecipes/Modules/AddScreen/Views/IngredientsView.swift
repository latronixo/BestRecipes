//
//  IngredientsView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
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
            HStack {
                Text("Ingredients")
                    .font(.poppinsSemibold(size: 18))
                
                Spacer()
                
                Button(action: {
                    viewModel.addIngredient()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                }
            }
            
            // MARK: - Ingredients List
            if viewModel.recipe.extendedIngredients?.isEmpty ?? true {
                Text("No ingredients added yet")
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(Array((viewModel.recipe.extendedIngredients ?? []).enumerated()), id: \.element.id) { index, ingredient in
                    IngredientRow(
                        viewModel: viewModel,
                        index: index
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview
#Preview {
    IngredientsView(viewModel: AddRecipeViewModel())
        .background(Color(.systemBackground))
}
