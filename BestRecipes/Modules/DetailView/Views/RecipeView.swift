//
//  RecipeView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct RecipeView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 20)
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
                        .shadow(color: .black, radius: 8, x:-2, y: 2)
                    
                } else {
                    
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .scaledToFit()
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 8, x:-2, y: 2)

                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                }

                FavoriteView(isFavor: detailVM.isFavorite, recipe: detailVM.recipe)
                    .offset(x: 130, y:-130)
                    
                
            }
            
            
            HStack{
                Spacer(minLength: 15)
                Image(systemName: "star.fill")
                
                Text(String(format: "%.1f", (detailVM.recipe.spoonacularScore ?? 0.0) /  20.0))
                Text(String(detailVM.recipe.aggregateLikes ?? 0))
                Spacer(minLength: 280)
            }
            
        }
        .onAppear() {
            
        }
    }
    
}

#Preview {
    RecipeView(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router()))
}
