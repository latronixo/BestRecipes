//
//  IngredientCellViewModel.swift
//  BestRecipes
//
//  Created by Валентин on 20.08.2025.
//

import SwiftUI

@MainActor
final class IngredientCellViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    var ingredient: Ingredient
    private var network = NetworkServices.shared
    
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    func loadImage() async {
        guard image == nil else { return }
        
        isLoading = true
        if let imageData = try? await network.fetchIngredientImageData(ingredient) {
            self.image = UIImage(data: imageData)
        }
        isLoading = false
    }
    
}
