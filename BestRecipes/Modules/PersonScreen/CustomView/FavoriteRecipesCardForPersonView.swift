//
//  FavoriteRecipesCardForPersonView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI

struct FavoriteRecipesCardForPersonView: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Фон карточки
            if #available(iOS 17.0, *) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.1))
                    .stroke(Color.black, lineWidth: 1)
                    .frame(height: 200)
            } else {
                // Fallback on earlier versions
            }
            
            // Изображение рецепта
            recipeImage
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Контент поверх изображения
            VStack(alignment: .leading) {
                // Рейтинг
                HStack {
                    ratingBadge
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
                
                // Информация о рецепте
                recipeInfo
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 200)
        .clipped()
    }
    
    // MARK: - Subviews
    
    private var recipeImage: some View {
        Group {
            if let imagePath = recipe.image {
                if let uiImage = loadImageFromPath(imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    placeholderImage
                }
            } else {
                placeholderImage
            }
        }
    }
    
    private func loadImageFromPath(_ path: String) -> UIImage? {
        // Получаем URL из строки пути
        let url = URL(fileURLWithPath: path)
        
        // Проверяем существование файла
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("Файл не существует по пути: \(path)")
            return nil
        }
        
        // Загружаем изображение
        if let imageData = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }
        
        return nil
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
            
            Text(String(format: "%.1f", recipe.spoonacularScore / 20))
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
    
    private var recipeInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(recipe.title)
                .font(.poppinsSemibold(size: 16))
                .foregroundColor(.white)
                .lineLimit(2)
            
            HStack(spacing: 12) {
                Text("\(recipe.extendedIngredients.count) ингредиентов")
                Text("•")
                Text("\(recipe.readyInMinutes) мин")
            }
            .font(.poppinsRegular(size: 12))
            .foregroundColor(.white.opacity(0.9))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

//#Preview{
//    FavoriteRecipesCardForPersonView()
//}
