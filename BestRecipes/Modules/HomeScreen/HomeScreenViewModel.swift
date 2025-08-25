//
//  HomeScreenViewModel.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class HomeScreenViewModel: ObservableObject {
    private var networkService = NetworkServices.shared
    private var dataService = CoreDataManager.shared
    @Published var text: String = ""
    @Published var currentCategory: RecipeCategory = .mainCourse
    @Published var categoryRecipes: [Recipe] = []
    @Published var trendingRecipes: [Recipe] = []
    @Published var randomRecipes: [Recipe] = []
    @Published var recentRecipes: [Recipe] = []
    @Published var largeImage: UIImage?
    
    let recipes = [
        Recipe.preview,
        Recipe.preview,
        Recipe.preview
    ]
    
    let cuisineCountry = CuisineType.allCases
    
    let mealTypes = CuisineType.allCases
    
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
            self.trendingRecipes = response.unique()
        } catch {
            self.trendingRecipes = recipes.unique()
            print("Ошибка при загрузке рецептов: \(error)")
        }
    }
    
    func fetchCategoryRecipes(category: RecipeCategory = .mainCourse) async {
        do {
            let response = try await networkService.searchRecipesByCategory(category)
            self.categoryRecipes = response.unique()
        } catch {
            self.categoryRecipes = recipes.unique()
            print("Ошибка при загрузке рецептов по категории: \(error)")
        }
    }
    
    func fetchRecentRecipes() async {
        self.recentRecipes = await dataService.fetchRecentRecipes()
       
        if recentRecipes.isEmpty {
            self.recentRecipes = recipes
        }
        self.recentRecipes = self.recentRecipes.unique()
    }
    
    @MainActor
    func toggleFavourite(with recipe: Recipe) async {
        await dataService.toggleFavorite(recipe: recipe)
    }
    
    
}

//расширение, добавляющее к массивам функцию unique, которая удаляет дублирующиеся элементы массива
extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted}
    }
}


