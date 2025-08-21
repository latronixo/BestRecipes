//
//  CategoryRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct CategoryRecipe: View {
    @State private var isFav: Bool = false
    var recipe: Recipe
    
    let onSelect: (Recipe) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 8) {
                Spacer().frame(height: 50)

                Text(recipe.title)
                    .font(.poppinsSemibold(size: 14))
                    .foregroundStyle(.text)

                Text("Time")
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                HStack() {
                    if let minutes = recipe.cookingMinutes {
                        Text("\(minutes) min")
                            .font(.poppinsSemibold(size: 12))
                            .foregroundStyle(.text)
                    } else {
                        Text("- min")
                            .font(.poppinsSemibold(size: 12))
                            .foregroundStyle(.text)
                    }
                   
                    Spacer()
                    
                    Button {
                        onSelect(recipe)
                        isFav.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)

                            Image(isFav ? "BookmarkActive" : "BookmarkForCard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                    }
                    .task {
                        isFav = await CoreDataManager.shared.isFavorite(id: recipe.id)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            .frame(width: 150)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

            
            
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
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .offset(y: -50)
                    case .failure:
                        Image("DishMock")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .offset(y: -50)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .frame(width: 150)
        .padding(.trailing, 10)
    }
}

