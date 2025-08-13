//
//  DetailViewModel.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import Foundation
import Combine
import SwiftUI

final class DetailViewModel: ObservableObject {
    
    @Published var recipe: Recipe
    @Published var instruction: [AnalyzedInstruction]
    private var sourceUrl: URL?
    private let router: Router
    
    init(recipe: Recipe, router: Router, instruction: [AnalyzedInstruction]) {
        
        self.recipe = recipe
        self.router = router
        self.instruction = instruction
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
