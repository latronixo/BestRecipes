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
    
    @Published var recipe: Recipe?
    @Published var isLoading = true
    @Published var isImageLoaded: Bool = false
    @Published var largeImage: UIImage?
    
    private var sourceUrl: URL?
    private let network = NetworkServices.shared
    
    init(recipeId: Int) {
    }
    
    func fetchRecipeDetails(id: Int) async {
        if self.recipe == nil {
            self.isLoading = true
        }
        
        do {
            let detailedRecipe = try await network.fetchRecipeInformation(id: id)
            self.recipe = detailedRecipe
            self.isLoading = false
            
            await fetchLargeImage()
        } catch {
            print("Error fetching recipe details: \(error)")
            self.isLoading = false
        }
    }
    
    func fetchLargeImage() async {
        guard let recipe = recipe, let imgData = try? await network.fetchRecipeImageData(recipe) else {
            return
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
}
