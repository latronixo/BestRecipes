//
//  MainRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct MainRecipe: View {
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
                                .frame(width: 300, height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .clipped()
                        case .failure:
                            Image("DishMock")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .clipped()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                        Text(String(format: "%.2f", recipe.spoonacularScore))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image("Bookmark")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                
            }
            Text(recipe.title)
                .fontWeight(.semibold)
                .lineLimit(2)

            HStack {
                Image("Chef")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                Text("By \(author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            

            Spacer()
        }
        .frame(width: 300)
        .padding(.trailing, 10)
    }
}

