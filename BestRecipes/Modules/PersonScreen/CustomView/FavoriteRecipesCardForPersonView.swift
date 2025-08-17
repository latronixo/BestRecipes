//
//  FavoriteRecipesCardForPersonView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI

struct FavoriteRecipesCardForPersonView: View{
    
    let recipe: MyRecipeCD
    
    var body: some View {
        ZStack {
            if #available(iOS 17.0, *) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.clear)
                    .stroke(.black, lineWidth: 1)
                    .frame(height: 200)
                    .overlay {
                        // Recipe Image
                        if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            } placeholder: {
                                Color.gray.opacity(0.3)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        } else {
                            Color.gray.opacity(0.3)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
            } else {
                // Fallback on earlier versions
            }
            
            VStack(alignment: .leading) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .foregroundStyle(.yellow)
                            .frame(width: 16, height: 16)
                        
                        Text(String(format: "%.1f", recipe.spoonacularScore / 20))
                            .font(.poppinsSemibold(size: 16))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.5))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                .offset(y: -40)
                
                Spacer()
                
                // Recipe Info
                VStack(alignment: .leading, spacing: 10) {
                    Text(recipe.title ?? "First first first")
                        .font(.poppinsSemibold(size: 16))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 16) {
                        Text("9 ingredients")  // Not count ingredients!
                        Text("|")
                        Text("\(recipe.readyInMinutes) min")
                    }
                    .font(.poppinsRegular(size: 12))
                    .foregroundStyle(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                )
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(height: 200)
    }
}

//#Preview{
//    FavoriteRecipesCardForPersonView()
//}
