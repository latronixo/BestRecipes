//
//  DetailViewModel.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class DetailViewModel: ObservableObject {
    
    @Published var recipe: Recipe
    //    @Published var instruction: [AnalyzedInstruction]
    
    @Published var isImageLoaded : Bool = false
    @Published var largeImage: UIImage?
    
    private var sourceUrl: URL?
    private let network = NetworkServices.shared
    private var dataService = CoreDataManager.shared
    
    init(recipe: Recipe, router: Router) {
        
        self.recipe = recipe
        self.router = router
        //MARK: Debug options!
        //Задержка в 2 секунды для отладки, убрать перед релизом!
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            Task {
//                await self.getRecipe()
                await self.fetchIngredients()
                await self.fetchLargeImage()
            }
        }
        
        
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
            
            await coreData.addRecent(recipe: detailedRecipe)
            await fetchLargeImage()
        } catch {
            print("Error fetching recipe details: \(error)")
            self.isLoading = false
        }
    }
    
    func fetchLargeImage() async {
        guard let img = await fetchImage(imageType: .largeImage) else { return }
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
        
        self.largeImage = UIImage(data: imgData)
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
    
    @MainActor
    func toggleFavourite(with recipe: Recipe) async {
        await dataService.toggleFavorite(recipe: recipe)
    }
    
//    func getRecipe() async {
//        
//        do {
//            let response = try await network.searchRecipesByCategory(.salad, numberOfResults: 1)
//            
//            self.recipe = response.first!
//            print(recipe)
//        } catch {
//            
//            print("Ошибка при загрузке рецептов по категории: \(error)")
//        }
//        
//    }
    
}
