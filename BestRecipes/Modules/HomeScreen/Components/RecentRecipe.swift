//
//  RecentRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct RecentRecipe: View {
    @ObservedObject var recentVM: RecentViewModel
    
    var recipe: Recipe
    var author: String {
        if recipe.creditsText?.localizedCaseInsensitiveContains("Foodista") == true {
            return "Foodista.com"
        } else {
            return recipe.creditsText ?? ""
        }
    }
    
    init(recentVM: RecentViewModel, recipe: Recipe) {
        self.recentVM = recentVM
        self.recipe = recipe
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .clipped()
                    case .failure:
                        
                                                
                        if recentVM.localImage != nil {
                            Image(uiImage: recentVM.localImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .clipped()
                        } else {
                            Image("DishMock")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .clipped()
                            
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            Text(recipe.title)
                .font(.poppinsSemibold(size: 14))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .topLeading)

            Text("By \(author)")
                .font(.poppinsRegular(size: 10))
                .foregroundColor(.gray)

            Spacer()
        }
        .frame(width: 120)
        .padding(.trailing, 10)
    }
    
    
}

