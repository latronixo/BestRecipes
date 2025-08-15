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

final class DetailViewModel: ObservableObject {
    
    @Published var recipe: Recipe
    @Published var instruction: [AnalyzedInstruction]
    
    @Published var isImageLoaded : Bool = false
    @Published var largeImage: UIImage?
    @Published var ingredientsImage: UIImage?
    @Published var ingredientsTuples: [(Ingredient, UIImage)] = []
    
    private var sourceUrl: URL?
    private let router: Router
    private let network = NetworkServices.shared
    
    init(recipe: Recipe, router: Router, instruction: [AnalyzedInstruction]) {
        
        self.recipe = recipe
        self.router = router
        self.instruction = instruction
        
    }
    
    func fetchIngredients() async {
        for ingredient in recipe.extendedIngredients {
            
            guard let img =  await fetchImage(imageType: .ingredientImage, ingredientExtended: ingredient) else { return }
            ingredientsTuples.append((ingredient, img))
            print("image loaded... \(ingredient.name)")
            print(ingredientsTuples)
            
        }
    }
    
    func fetchImage(imageType: ImageType,  ingredientExtended: Ingredient? = nil) async -> UIImage? {
        
        switch imageType {
            
        case .largeImage:
            guard let imgData = try? await network.fetchRecipeImageData(recipe) else {
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
//            self.ingredientsTuples.append((ingredient, UIImage(data: imgData) ?? UIImage(systemName: "fish")!))
//            self.ingredientsImage = UIImage(data: imgData)
            
            return UIImage(data: imgData)
            
        }
        
    }
    
    
    
    func makeInstructionsText(with instructions: [AnalyzedInstruction]) -> String {
        
        guard let instruction = instructions.first, instruction.steps?.capacity != 1
        else {
            if let url = URL(string: recipe.sourceUrl ?? "") {
                sourceUrl = url
            }
            print("sourceUrl")
            return ""
        }
        
        var finalString = ""
        for step in instruction.steps! {
            finalString += "\(step.number). \(step.step)\n\n"
        }
        
        return finalString
    }
    
    func goBack() {
        router.goBack()
    }
    
    
    
}
