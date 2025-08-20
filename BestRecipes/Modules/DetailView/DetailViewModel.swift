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
    
    @Published var recipe: Recipe
//    @Published var instruction: [AnalyzedInstruction]
    
    @Published var isImageLoaded : Bool = false
    @Published var largeImage: UIImage?
    @Published var ingredientsImage: UIImage?
    @Published var ingredientsTuples: [(Ingredient, UIImage?)] = []
    @Published var isFavorite: Bool = false
    
    private var sourceUrl: URL?
    private let router: Router
    private let network = NetworkServices.shared
    private let coreData = CoreDataManager.shared
    
    init(recipe: Recipe, router: Router) {
        
        self.recipe = recipe
        self.router = router
//MARK: Debug options!
        //Задержка в 2 секунды для отладки, убрать перед релизом!
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            Task {
                
                await self.checkIfFavourite()
                await self.fetchIngredients()
                await self.fetchLargeImage()
            }
//        }
        
        
    }
    
    func fetchIngredients() async {
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
    
        guard let img = await  fetchImage(imageType: .largeImage) else { return }
            largeImage = img
        
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
            
            return UIImage(data: imgData)
            
        }
        
    }
    
    
    
    func makeInstructionsText(with instructions: [AnalyzedInstruction]?) -> String {
        
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
    
    private func checkIfFavourite() async {
        isFavorite = await coreData.isFavorite(id: recipe.id)
    }
    
    func toggleFavourite() async {
        await coreData.toggleFavorite(recipe: recipe)
    }
    
//    func goBack() {
//        router.goBack()
//    }
    
    
    
}
