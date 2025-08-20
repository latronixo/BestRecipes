//
//  DetailView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var detailVM: DetailViewModel
    @EnvironmentObject private var router: Router

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
                        
                        HStack {
                            Text("Ingredients")
                                .font(.poppinsSemibold(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            Spacer()
                            
                            let count = recipe.extendedIngredients?.count ?? 0
                            
                            Text("\(count) \(count == 1 ? "item" : "items")")
                                .font(.poppinsRegular(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .padding([.horizontal, .top])
                        
                        ForEach(recipe.extendedIngredients ?? [], id: \.id) { ingredient in
                            IngredientsViewCell(ingredient: ingredient)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                        }
                    }
                }
                .navigationTitle("Recipe detail")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            router.goBack()
                        }) {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(.primary)
                        }
                    }
                }
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
