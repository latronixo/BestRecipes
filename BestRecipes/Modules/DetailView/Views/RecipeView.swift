//
//  RecipeView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct RecipeView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    
    @State var isFavorite: Bool = false
    
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 15)
                Text(detailVM.recipe.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 25))
                Spacer(minLength: 15)
                
            }
            
            ZStack {
                if let img = detailVM.largeImage {
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .scaledToFit()
                } else {
                    
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .scaledToFit()
                        .foregroundStyle(.regularMaterial)

                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        
                }

                FavoriteView(recipeID: detailVM.recipe.id)
                    .offset(x: 140, y: -140)
                
            }
            
            HStack{
                Spacer(minLength: 20)
                Image(systemName: "star.fill")
                
                Text(String(format: "%.1f", (detailVM.recipe.spoonacularScore ?? 0.0) / 20.0))
                Text(String(detailVM.recipe.aggregateLikes ?? 0))
                Spacer(minLength: 270)
            }
            
        }
        .onAppear() {
            
        }
    }
    
}

#Preview {
    RecipeView(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router()))
}
