//
//  FavoriteRecipesCardForPersonView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI
import UIKit

struct FavoriteRecipesCardForPersonView: View {
    let recipe: Recipe
    @State private var loadedImage: UIImage? = nil
    
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
            imageContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Контент поверх изображения
            contentOverlay
        }
        .frame(height: 200)
        .onAppear {
            loadImage()
        }
    }
    
    @ViewBuilder
    private var imageContent: some View {
        if let image = loadedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            placeholderImage
        }
    }
    
    private func loadImage() {
        // Сначала пробуем загрузить из imageData
        if let imageData = recipe.image {
            loadedImage = FileManagerHelper.shared.loadImage(from: imageData)
            return
        }
        
        // Если нет imageData, пробуем загрузить по пути
        guard let imagePath = recipe.image else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(fileURLWithPath: imagePath)
            
            // Проверяем, что путь находится в sandbox
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            guard url.path.hasPrefix(documentsURL.path) else {
                print("Попытка доступа за пределы sandbox: \(imagePath)")
                return
            }
            
            // Загружаем изображение
            if FileManager.default.fileExists(atPath: url.path),
               let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            }
        }
    }
    
    private var placeholderImage: some View {
        Color.gray.opacity(0.3)
    }
    
    // Остальные компоненты без изменений
    @ViewBuilder
    private var contentOverlay: some View {
        VStack(alignment: .leading) {
            
            Spacer()
            
            recipeInfo
        }
    }
    
    private var recipeInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(recipe.title)
                .font(.poppinsSemibold(size: 16))
                .foregroundColor(.white)
                .lineLimit(2)
            
            HStack(spacing: 12) {
                Text("\(recipe.extendedIngredients?.count ?? 4) ингредиентов")
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
