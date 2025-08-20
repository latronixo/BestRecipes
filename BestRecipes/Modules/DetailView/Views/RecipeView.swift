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
                Spacer(minLength: 20)
                Text(detailVM.recipe?.title ?? "Loading recipe...")
                    .font(.poppinsSemibold(size: 24))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                Spacer(minLength: 20)
            }
                
            ZStack {
                if let img = detailVM.largeImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 380, height: 380)
                        .cornerRadius(40)
                } else {
                    
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .foregroundStyle(.regularMaterial)

                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                }
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
    let viewModel = DetailViewModel(recipeId: 716429)
    RecipeView(detailVM: viewModel)
        .environmentObject(Router())
}
