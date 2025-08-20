//
//  DetailViewModel.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import Foundation
import Combine
import SwiftUI

enum ImageType {
    case largeImage
    case ingredientImage
}

@MainActor
final class DetailViewModel: ObservableObject {
    
    @Published var recipe: Recipe?
    @Published var isLoading = true
//    @Published var instruction: [AnalyzedInstruction]
    
    @Published var isImageLoaded : Bool = false
    @Published var largeImage: UIImage?
    @Published var ingredientsImage: UIImage?
    @Published var ingredientsTuples: [(Ingredient, UIImage?)] = []
    
    private var sourceUrl: URL?
    
    @EnvironmentObject private var router: Router
    private let network = NetworkServices.shared
    
    init(recipeId: Int) {
    }
    
    func fetchRecipeDetails(id: Int) async {
        if self.recipe == nil {
            self .isLoading = true
        }
        
        do {
            let detailedRecipe = try await network.fetchRecipeInformation(id: id)
            self.recipe = detailedRecipe
            self.isLoading = false
            
            //параллельно запускаем загрузку всех картинок
            await fetchLargeImage()
            await fetchIngredients()
        } catch {
            print("Error fetching recipe details: \(error)")
            self.isLoading = false
        }
    }
    
    func fetchIngredients() async {
        guard let recipe = recipe else { return }
        for ingredient in recipe.extendedIngredients ?? [] {
            
            if let img = await fetchImage(imageType: .ingredientImage, ingredientExtended: ingredient){
                ingredientsTuples.append((ingredient, img))
                print("image loaded... \(ingredient.name)")
                print(ingredientsTuples)
            
            } else { ingredientsTuples.append((ingredient, nil))
                print("image not loaded... \(ingredient.name)")
                print(ingredientsTuples) }
            
        }
    }
    
    func fetchLargeImage() async {
        guard let img = await fetchImage(imageType: .largeImage) else { return }
        largeImage = img
    }
    
    func fetchImage(imageType: ImageType,  ingredientExtended: Ingredient? = nil) async -> UIImage? {
        
        switch imageType {
            
        case .largeImage:
            guard let recipe = recipe, let imgData = try? await network.fetchRecipeImageData(recipe) else {
                return nil
            }
            
            self.largeImage = UIImage(data: imgData)
            return UIImage(data: imgData)
            
        case .ingredientImage:
            
            guard let ingredient = ingredientExtended else {
                ingredientsImage = UIImage(systemName: "fish")
                return nil
            }
            guard let imgData = try? await network.fetchIngredientImageData(ingredient) else {
                return nil
            }
            
            return UIImage(data: imgData)
            
        }
        
    }
    
    
    
    func makeInstructionsText(with instructions: [AnalyzedInstruction]?) -> String {
        guard let recipe = recipe else { return "" }
        guard let instruction = instructions?.first, instruction.steps?.capacity != 1
        else {
            if let url = URL(string: recipe.sourceUrl ?? "") {
                sourceUrl = url
            }
            print("sourceUrl")
            return ""
        }
        
        var finalString = ""
        for step in instruction.steps ?? [] {
            finalString += "\(step.number). \(step.step)\n\n"
        }
        
        return finalString
    }
    
    func goBack() {
        router.goBack()
    }
    
    
    
}
