//
//  Secrets.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 18.08.2025.
//

import Foundation

struct Secrets {
    static let apiKey = "a1df0d471f714100b58221af46a5cb2c"
    
    static let recipeIdApi = "https://api.spoonacular.com/recipes/7/information?apiKey=a1df0d471f714100b58221af46a5cb2c&includeNutrition=true"
    
    static let randomApi = "https://api.spoonacular.com/recipes/random?apiKey=a1df0d471f714100b58221af46a5cb2c&number=7"
    
    static let searchApi = "https://api.spoonacular.com/recipes/complexSearch?apiKey=a1df0d471f714100b58221af46a5cb2c&query=pasta&number=10&addRecipeInformation=true"
    
    static let searchApiCuisine = "https://api.spoonacular.com/recipes/complexSearch?apiKey=a1df0d471f714100b58221af46a5cb2c&cuisine=italian&number=10&addRecipeInformation=true"
}
