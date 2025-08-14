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
    @Published var recipe: NewRecipe
    @Published var imagePath: String?
    @Published var showingImagePicker = false
    @Published var showingServingsPicker = false
    @Published var showingCookTimePicker = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        !recipe.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !recipe.ingredients.isEmpty &&
        recipe.ingredients.allSatisfy { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    var servingsOptions: [Int] {
        Array(1...12)
    }
    
    var cookTimeOptions: [Int] {
        [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 75, 90, 105, 120]
    }
    
    // MARK: - Initialization
    init() {
        self.recipe = NewRecipe()
    }
    
    // MARK: - Recipe Title Management
    func updateTitle(_ title: String) {
        recipe.title = title
    }
    
    // MARK: - Image Management
    func selectImage(path: String?) {
        imagePath = path
        recipe.imagePath = path
    }
    
    func removeImage() {
        imagePath = nil
        recipe.imagePath = nil
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
        recipe.cookTimeMinutes = minutes
    }
    
    func cookTimeDisplayValue() -> String {
        return "\(recipe.cookTimeMinutes) min"
    }
    
    // MARK: - Ingredients Management
    func addIngredient() {
        let newIngredient = NewIngredient()
        recipe.ingredients.append(newIngredient)
    }
    
    func removeIngredient(at index: Int) {
        guard index < recipe.ingredients.count else { return }
        recipe.ingredients.remove(at: index)
    }
    
    func updateIngredientName(at index: Int, name: String) {
        guard index < recipe.ingredients.count else { return }
        recipe.ingredients[index].name = name
    }
    
    func updateIngredientQuantity(at index: Int, quantity: String) {
        guard index < recipe.ingredients.count else { return }
        recipe.ingredients[index].quantity = quantity
    }
    
    // MARK: - Instructions Management
    func updateInstructions(_ instructions: String) {
        recipe.instructions = instructions
    }
    
    // MARK: - Recipe Creation
    func createRecipe() async {
        guard isFormValid else {
            alertMessage = "Please fill in all required fields"
            showingAlert = true
            return
        }
        
        // Here you can add logic for saving to Core Data or sending to server
        print("Creating recipe: \(recipe.title)")
        
        // Show success notification
        alertMessage = "Recipe created successfully!"
        showingAlert = true
        
        // Reset form
        resetForm()
    }
    
    // MARK: - Form Reset
    private func resetForm() {
        recipe = NewRecipe()
        imagePath = nil
    }
    
    // MARK: - Validation
    func validateForm() -> Bool {
        if recipe.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Please enter recipe title"
            showingAlert = true
            return false
        }
        
        if recipe.ingredients.isEmpty {
            alertMessage = "Please add at least one ingredient"
            showingAlert = true
            return false
        }
        
        for (index, ingredient) in recipe.ingredients.enumerated() {
            if ingredient.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                alertMessage = "Please enter ingredient name \(index + 1)"
                showingAlert = true
                return false
            }
        }
        
        return true
    }
}
