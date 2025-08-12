//
//  HomeScreenViewModel.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//

import Foundation

@MainActor
class HomeScreenViewModel: ObservableObject {
    private var networkService = NetworkServices.shared
    private var dataService = CoreDataManager.shared
    @Published var currentCategory: CuisineType = .french
    @Published var categoryRecipes: [Recipe] = []
    @Published var trendingRecipes: [Recipe] = []
    @Published var recentRecipes: [Recipe] = []
    
    
    let mealTypes = [
        "Main Course",
        "Side Dish",
        "Dessert",
        "Appetizer",
        "Salad",
        "Bread",
        "Breakfast",
        "Soup",
        "Beverage",
        "Sauce",
        "Marinade",
        "Fingerfood",
        "Snack",
        "Drink"
    ]
    
    init() {
        Task {
            await fetchTrendingRecipes()
            await fetchCategoryRecipes()
            await fetchRecentRecipes()
        }
    }
    
    func fetchTrendingRecipes() async {
        do {
            let response = try await networkService.fetchRandomRecipes(numberOfRecipes: 10)
            self.trendingRecipes = response.recipes
        } catch {
            print("Ошибка при загрузке рецептов: \(error)")
        }
    }
    
    func fetchCategoryRecipes() async {
        do {
            let response = try await networkService.searchRecipesByCuisine(currentCategory)
            self.categoryRecipes = response.results
        } catch {
            print("Ошибка при загрузке рецептов по категории: \(error)")
        }
    }
    
    func fetchRecentRecipes() async {
        do {
            let response = try await networkService.fetchRandomRecipes(numberOfRecipes: 10)
            self.recentRecipes = response.recipes
        } catch {
            print("Ошибка при загрузке недавних рецептов: \(error)")
        }
    }
    
    func toggleFavourite(with recipe: Recipe) {
        print("ADDED")
    }
}




