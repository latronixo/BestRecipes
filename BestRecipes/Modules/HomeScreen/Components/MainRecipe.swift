//
//  MainRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct MainRecipe: View {
    @State private var isFav: Bool = false
    var recipe: Recipe
    
    var author: String {
        if recipe.creditsText?.localizedCaseInsensitiveContains("Foodista") == true {
            return "Foodista.com"
        } else {
            return recipe.creditsText ?? ""
        }
    }
    
    let onSelect: (Recipe) -> Void
    
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
                
                HStack() {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                        Text("\((recipe.spoonacularScore ?? 0.0) / 20, specifier: "%.2f")")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button {
                        onSelect(recipe)
                        isFav.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 35, height: 35)

                            Image(isFav ? "BookmarkActive" : "BookmarkForCard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                    }
                    .task {
                        isFav = await CoreDataManager.shared.isFavorite(id: recipe.id)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            
            Text(recipe.title.capitalized)
                .font(.poppinsSemibold(size: 16))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .topLeading)

            HStack {
                Image("Chef")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                Text("By \(author)")
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Spacer()
        }
        .frame(width: 300)
        .padding(.trailing, 10)
    }
}


