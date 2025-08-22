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

            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            
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
        .onAppear(perform: loadImage)
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private var imageContent: some View {
        if let image = loadedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemGray4))
        }
    }
    
    private var recipeInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ИСПРАВЛЕНИЕ №1: Проверяем title на .isEmpty
            if !recipe.title.isEmpty {
                 Text(recipe.title)
                    .font(.poppinsSemibold(size: 16))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .shadow(radius: 3)
            }
            
            let ingredientsCount = recipe.extendedIngredients?.count ?? 0
            let cookTime = recipe.readyInMinutes 
            
            if ingredientsCount > 0 || cookTime > 0 {
                HStack(spacing: 8) {
                    if ingredientsCount > 0 {
                        Text("\(ingredientsCount) \(ingredientsCount == 1 ? "ingredient" : "ingredients")")
                    }
                    
                    if ingredientsCount > 0 && cookTime > 0 {
                        Text("•")
                    }
                    
                    if cookTime > 0 {
                        Text("\(cookTime) min")
                    }
                }
                .font(.poppinsRegular(size: 12))
                .foregroundColor(.white)
                .shadow(radius: 3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "trash")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Private Methods
    
    private func loadImage() {
        guard let imageName = recipe.image else { return }
        self.loadedImage = FileManagerHelper.shared.loadImage(from: imageName)
    }
}

// MARK: - Preview

#Preview {
    // Вариант 1: Рецепт с полными данными
    let fullRecipe = Recipe.preview
    
    // Вариант 2: Рецепт только с картинкой (копируем и обнуляем)
    var emptyRecipe = Recipe.preview
    emptyRecipe.title = ""
    emptyRecipe.extendedIngredients = []
    emptyRecipe.readyInMinutes = 0
    
    return VStack(spacing: 20) {
        FavoriteRecipesCardForProfileView(recipe: fullRecipe, onDelete: {
            print("Delete tapped!")
        })
        
        FavoriteRecipesCardForProfileView(recipe: emptyRecipe, onDelete: {
            print("Delete tapped!")
        })
    }
    .padding()
}

//#Preview{
//    FavoriteRecipesCardForProfileView(recipe: Recipe.preview, onDelete: {
//        print("Delete tapped!")
//    })
//    .padding()
//}
