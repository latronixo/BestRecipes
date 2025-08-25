//
//  SearchRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//

import SwiftUI

struct SearchRecipe: View {
    var recipe: Recipe
    
    var author: String {
        if recipe.creditsText?.localizedCaseInsensitiveContains("Foodista") == true {
            return "Foodista.com"
        } else {
            return recipe.creditsText ?? ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .top) {
                
                if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.clear, lineWidth: 0)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        case .failure:
                            Image("DishMock")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                

            }
            
        }
        .frame(height: 200)
        .overlay(alignment: .bottomLeading, content: {
            VStack {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.black)
                    Text("\((recipe.spoonacularScore ?? 0.0) / 20, specifier: "%.1f")")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    Text(recipe.title)
                        .font(.poppinsSemibold(size: 16))
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                    
                    Text("\(recipe.extendedIngredients?.count ?? Int.random(in: 3...8)) ingredients | \(recipe.cookingMinutes ?? 0) min")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .foregroundStyle(.white)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: [
                    Color.black.opacity(0),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.4)
                ], startPoint: .top, endPoint: .bottom)
            )
        })
        .padding(.bottom)
    }
}
