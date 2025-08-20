//
//  DetailView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var detailVM: DetailViewModel
    let recipeId: Int
    
    init(recipeId: Int) {
        self.recipeId = recipeId
        _detailVM = StateObject(wrappedValue: DetailViewModel(recipeId: recipeId))
    }
    
    var body: some View {
        ZStack{
            if detailVM.isLoading {
                ProgressView("Loading Recipe...")
            } else if let recipe = detailVM.recipe {
                ScrollView {
                    VStack {
                        RecipeView(detailVM: detailVM)
                        RecipeTextView(detailVM: detailVM, instruction: recipe.analyzedInstructions)
                        
                        ForEach(recipe.extendedIngredients ?? [], id: \.id) { ingredient in
                            IngredientsViewCell(
                                detailVM: detailVM,
                                id: ingredient.id,
                                text: ingredient.name,
                                weight: ingredient.measures?.metric?.amount ?? 0,
                                unitShort: ingredient.measures?.metric?.unitShort ?? "",
                                image: detailVM.ingredientsImage
                            )
                        }
                    }
                }
                .navigationTitle("Recipe Detail")
            } else {
                Text("Failed to load recipe details")
            }
        }
        .task {
            await detailVM.fetchRecipeDetails(id: recipeId)
        }
    }
}

#Preview {
    NavigationView {
        DetailView(recipeId: 716429)
            .environmentObject(Router())
    }
}
