//
//  DetailView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    
    
    
    init(detailVM: DetailViewModel) {
        
        self.detailVM = detailVM
        
    }
    
    
    var body: some View {
            
            
            VStack {
                ScrollView {
                    RecipeView(detailVM: detailVM)
                    RecipeTextView(detailVM: detailVM, instruction: detailVM.recipe.analyzedInstructions)
        
                    ForEach(detailVM.recipe.extendedIngredients ?? [], id: \.id) { ingredient in
                        
                        IngredientsViewCell(detailVM: detailVM, id: ingredient.id,
                                            text: ingredient.name,
                                            weight: ingredient.measures?.metric?.amount ?? 0,
                                            unitShort: ingredient.measures?.metric?.unitShort ?? "",
                                            image: detailVM.ingredientsImage)
                        
                    }
                    
                }
            }
            .navigationTitle("Recipe Detail")
            
            
//            .toolbar {
//                               ToolbarItem(placement: .navigationBarLeading) {
//                                   Button(action: {
//                                       router.goBack()
//                                   }) {
//                                       Image(systemName: "arrow.backward")
//                                           .foregroundColor(.primary)
//                                   }
//                               }
//                           }
        
 
    }
    
  
    
}

#Preview {
    DetailView(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router()))
}
