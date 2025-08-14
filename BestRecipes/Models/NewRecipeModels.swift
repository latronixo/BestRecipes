//
//  NewRecipeModels.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import Foundation

// MARK: - New Recipe Model
struct NewRecipe: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var imagePath: String?
    var servings: Int
    var cookTimeMinutes: Int
    var ingredients: [NewIngredient]
    var instructions: String
    var createdAt: Date
    
    init(title: String = "",
         imagePath: String? = nil,
         servings: Int = 1,
         cookTimeMinutes: Int = 20,
         ingredients: [NewIngredient] = [],
         instructions: String = "") {
        self.title = title
        self.imagePath = imagePath
        self.servings = servings
        self.cookTimeMinutes = cookTimeMinutes
        self.ingredients = ingredients
        self.instructions = instructions
        self.createdAt = Date()
    }
}

// MARK: - New Ingredient Model
struct NewIngredient: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var quantity: String
    
    init(name: String = "", quantity: String = "") {
        self.name = name
        self.quantity = quantity
    }
}

// MARK: - Recipe Parameter Model
struct RecipeParameter: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    var value: String
    let unit: String?
    
    init(title: String, icon: String, value: String, unit: String? = nil) {
        self.title = title
        self.icon = icon
        self.value = value
        self.unit = unit
    }
}

// MARK: - Preview Support
#if DEBUG
extension NewRecipe {
    static let preview = NewRecipe(
        title: "Naija lunch box ideas for work",
        servings: 3,
        cookTimeMinutes: 20,
        ingredients: [
            NewIngredient(name: "Pasta", quantity: "250gr"),
            NewIngredient(name: "Green Beans", quantity: "150gr")
        ],
        instructions: "Cook pasta according to package instructions..."
    )
}

extension NewIngredient {
    static let preview = NewIngredient(name: "Pasta", quantity: "250gr")
}
#endif
