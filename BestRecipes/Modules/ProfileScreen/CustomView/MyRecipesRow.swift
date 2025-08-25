//
//  MyRecipesRow.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI
import UIKit

struct MyRecipesRow: View {
    let recipe: Recipe
    @State private var loadedImage: UIImage? = nil
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Фон карточки
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
            
            // Основное содержимое
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                content
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            loadImage()
        }
        .onChange(of: recipe) { _ in
            // Сбрасываем состояние при изменении рецепта
            loadedImage = nil
            loadImage()
        }
    }
    
    private var content: some View {
        ZStack(alignment: .bottom) {
            // Изображение рецепта
            imageContent
            
            // Контент поверх изображения
            contentOverlay
        }
    }
    
    @ViewBuilder
    private var imageContent: some View {
        if let image = loadedImage {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .transition(.opacity)// Анимация появления
        } else {
            placeholderImage
        }
    }
    
    private func loadImage() {
        guard loadedImage == nil else { return }
        isLoading = true
        
        // Сначала пробуем загрузить из imageData
        if let imageData = recipe.image {
            loadedImage = FileManagerHelper.shared.loadImage(from: imageData)
            isLoading = false
            return
        }
        
        // Если нет imageData, пробуем загрузить по пути
        guard let imagePath = recipe.image else {
            isLoading = false
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(fileURLWithPath: imagePath)
            
            // Проверяем, что путь находится в sandbox
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            guard url.path.hasPrefix(documentsURL.path) else {
                print("Попытка доступа за пределы sandbox: \(imagePath)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            // Загружаем изображение
            if FileManager.default.fileExists(atPath: url.path),
               let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                
                DispatchQueue.main.async {
                    self.loadedImage = image
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private var placeholderImage: some View {
        Color.gray.opacity(0.3)
    }
    
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
                let count = recipe.extendedIngredients?.count ?? 4
                Text("\(count) \(count == 1 ? "ingredient" : "ingredietnts")")
                Text("|")
                Text("\(recipe.readyInMinutes) min")
            }
            .font(.poppinsRegular(size: 12))
            .foregroundColor(.white.opacity(0.9))
        }
        .padding(16)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
    }
}
