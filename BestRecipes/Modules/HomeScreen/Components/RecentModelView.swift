//
//  RecentModelView.swift
//  BestRecipes
//
//  Created by Sergey on 25.08.2025.
//

import Foundation
import SwiftUI

@MainActor
class RecentViewModel: ObservableObject {
    
    private let network = NetworkServices.shared
    private let coreData = CoreDataManager.shared
    
    @Published var localImage: UIImage?
    @Published var recipe: Recipe
    
    init(recipe: Recipe) {
        
        self.recipe = recipe
        Task {
            await fetchLocalImage()
        }
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


