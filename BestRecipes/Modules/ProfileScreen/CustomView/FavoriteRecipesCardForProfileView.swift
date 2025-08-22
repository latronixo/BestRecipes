//
//  FavoriteRecipesCardForProfileView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI
import UIKit

struct FavoriteRecipesCardForProfileView: View {
    let recipe: Recipe
    var onDelete: () -> Void
    
    @State private var loadedImage: UIImage?
    
    var body: some View {
        ZStack{
            imageContent

            VStack {
                HStack {
                    Spacer()
                    deleteButton
                }
                Spacer()
                recipeInfo
            }
            .padding(12)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .onAppear {
            loadImage()
        }
    }
    
    // MARK: UI Components
    
    @ViewBuilder
    private var imageContent: some View {
        if let image = loadedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            //placeholderImage
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemGray4))
        }
    }
    
    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "trash")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.red)
                .padding(10)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var recipeInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.title)
                .font(.poppinsSemibold(size: 16))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            HStack(spacing: 12) {
                let textIngredients = recipe.extendedIngredients?.count ?? 4 == 1 ? "ingredient" : "ingredients"
                Text("\(recipe.extendedIngredients?.count ?? 4) \(textIngredients)")
                Text("|")
                Text("\(recipe.readyInMinutes) min")
            }
            .font(.poppinsRegular(size: 12))
            .foregroundColor(.secondary)
            .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    private func loadImage() {
        guard let imageName = recipe.image else { return }
        self.loadedImage = FileManagerHelper.shared.loadImage(from: imageName)
    }
    
    private var placeholderImage: some View {
        Color.gray.opacity(0.3)
    }

    private var ratingBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.yellow)
            
            Text(String(format: "%.1f", (recipe.spoonacularScore ?? 0.0) / 20))
                .font(.poppinsSemibold(size: 14))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.5))
        )
    }
}

#Preview{
    FavoriteRecipesCardForProfileView(recipe: Recipe.preview, onDelete: {
        print("Delete tapped!")
    })
    .padding()
}
