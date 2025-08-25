//
//  RecipeCardViewModel.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 21.08.2025.
//

import Foundation
import SwiftUI

@MainActor
final class RecipeCardViewModel: ObservableObject {
    
    private let network = NetworkServices.shared
    private let coreData = CoreDataManager.shared
    
    @Published var localImage: UIImage?
    @Published var recipe: Recipe
    @Published var isBookmarked: Bool
    @Published var imageURL: URL?
    @Published var faviconURL: URL?
    
    init(recipe: Recipe, isBookmarked: Bool = false) {
        self.recipe = recipe
        self.isBookmarked = isBookmarked
        self.imageURL = URL(string: recipe.image ?? "")
        self.faviconURL = self.generateFaviconURL()
        Task {
            await fetchLocalImage()
        }
    }
    
    var title: String { recipe.title }
    var readyInMinutes: Int { recipe.readyInMinutes }
    var sourceName: String? { recipe.sourceName }
    
    func formatTime(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return String(format: "%02d:%02d", h, m)
    }
    
    func formattedRating() -> String {
        let score = recipe.spoonacularScore ?? 100
        let fiveScale = max(0, min(5, score / 20.0))
        return String(format: "%.1f", fiveScale).replacingOccurrences(of: ".", with: ",")
    }
    
    func generateFaviconURL() -> URL? {
        // try sourceUrl, then spoonacularSourceUrl
        let candidates = [recipe.sourceUrl, recipe.spoonacularSourceUrl]
        for link in candidates {
            if let link, let pageURL = URL(string: link), let host = pageURL.host {
                // Google S2
                if let url = URL(string: "https://www.google.com/s2/favicons?domain=\(host)&sz=64") {
                    return url
                }
                // favicon.ico
                if let url = URL(string: "https://\(host)/favicon.ico") {
                    return url
                }
            }
        }
        return nil
    }
    
    func toggleBookmark() {
        isBookmarked.toggle()
    }
    
    func fetchImage() async -> UIImage? {

            guard let imgData = try? await network.fetchRecipeImageData(recipe) else {
                return nil
            }
            
            self.localImage = UIImage(data: imgData)
            return UIImage(data: imgData)
            
              
    }
    
    func fetchLocalImage() async {
    
        guard let img = await  fetchImage() else {
            
            // Сначала пробуем загрузить из imageData
            if let imageData = recipe.image {
                localImage = FileManagerHelper.shared.loadImage(from: imageData)
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
                        self.localImage = image
                    }
                }
            }
            
            return }
            localImage = img
        
    }
    
}
