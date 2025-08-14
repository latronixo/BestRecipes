//
//  AddRecipeViewModel.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import Foundation

// MARK: - Add Recipe View Model
@MainActor
final class AddRecipeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var recipe: Recipe
    @Published var imagePath: String?
    @Published var showingServingsPicker = false
    @Published var showingCookTimePicker = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        !recipe.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !recipe.extendedIngredients.isEmpty &&
        recipe.extendedIngredients.allSatisfy { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    var servingsOptions: [Int] {
        Array(1...12)
    }
    
    var cookTimeOptions: [Int] {
        [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 75, 90, 105, 120]
    }
    
    // MARK: - Initialization
    init() {
        self.recipe = Recipe.createEmpty()
    }
    
    // MARK: - Recipe Title Management
    func updateTitle(_ title: String) {
        recipe.title = title
    }
    
    // MARK: - Image Management
    func selectImage(path: String?) {
        imagePath = path
        recipe.image = path
        recipe.imageType = path?.components(separatedBy: ".").last
    }
    
    func removeImage() {
        imagePath = nil
        recipe.image = nil
        recipe.imageType = nil
    }
    
    // MARK: - Servings Management
    func updateServings(_ servings: Int) {
        recipe.servings = servings
    }
    
    func servingsDisplayValue() -> String {
        return String(format: "%02d", recipe.servings)
    }
    
    // MARK: - Cook Time Management
    func updateCookTime(_ minutes: Int) {
        recipe.readyInMinutes = minutes
        recipe.cookingMinutes = minutes
    }
    
    func cookTimeDisplayValue() -> String {
        return "\(recipe.readyInMinutes) min"
    }
    
    // MARK: - Ingredients Management
    func addIngredient() {
        let newIngredient = Ingredient.createEmpty()
        recipe.extendedIngredients.append(newIngredient)
    }
    
    func removeIngredient(at index: Int) {
        guard index < recipe.extendedIngredients.count else { return }
        recipe.extendedIngredients.remove(at: index)
    }
    
    func updateIngredientName(at index: Int, name: String) {
        guard index < recipe.extendedIngredients.count else { return }
        recipe.extendedIngredients[index].name = name
        recipe.extendedIngredients[index].nameClean = name
        recipe.extendedIngredients[index].originalName = name
    }
    
    func updateIngredientQuantity(at index: Int, quantity: String) {
        guard index < recipe.extendedIngredients.count else { return }
        recipe.extendedIngredients[index].amount = Double(quantity) ?? 1.0
        recipe.extendedIngredients[index].original = "\(quantity) \(recipe.extendedIngredients[index].name)"
    }
    
    // MARK: - Instructions Management
    func updateInstructions(_ instructions: String) {
        recipe.instructions = instructions
        recipe.summary = instructions
    }
    
    // MARK: - Recipe Creation
    func createRecipe() async {
        guard isFormValid else {
            alertMessage = "Please fill in all required fields"
            showingAlert = true
            return
        }
        
        await CoreDataManager.shared.addMyRecipe(recipe: recipe)
        
        alertMessage = "Recipe created successfully!"
        showingAlert = true
        
        resetForm()
    }
    
    // MARK: - Form Reset
    private func resetForm() {
        recipe = Recipe.createEmpty()
        imagePath = nil
    }
    
    // MARK: - Validation
    func validateForm() -> Bool {
        if recipe.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Please enter recipe title"
            showingAlert = true
            return false
        }
        
        if recipe.extendedIngredients.isEmpty {
            alertMessage = "Please add at least one ingredient"
            showingAlert = true
            return false
        }
        
        for (index, ingredient) in recipe.extendedIngredients.enumerated() {
            if ingredient.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                alertMessage = "Please enter ingredient name \(index + 1)"
                showingAlert = true
                return false
            }
        }
        
        return true
    }
}
