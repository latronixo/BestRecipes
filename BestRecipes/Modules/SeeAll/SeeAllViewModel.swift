//
//  SeeAllViewModel.swift
//  BestRecipes
//
//  Created by Валентин on 19.08.2025.
//

import SwiftUI

@MainActor
final class SeeAllViewModel: ObservableObject {
    private var networkService = NetworkServices.shared
    private var dataService = CoreDataManager.shared
    @Published var trendingRecipes: [Recipe] = []

    let recipes = [
        Recipe.preview,
        Recipe.preview,
        Recipe.preview
    ]
    
    init() {
    //    Task {
    //        await fetchTrendingRecipes()
    //    }
    }
    
    func fetch(by type: SeeAllCategory) async {
        switch type {
        case .trending:
            await fetchTrendingRecipes()
        case .recent:
            await fetchRecentRecipes()
        case .popularCuisine:
            await fetchTrendingRecipes()
        case .byPopularCuisine(let cuisine):
            await fetchCuisineRecipes(cuisine: cuisine)
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
    
    func fetchCuisineRecipes(cuisine: CuisineType) async {
        do {
            let response = try await networkService.searchRecipesByCuisine(cuisine)
            self.trendingRecipes = response.unique()
        } catch {
            self.trendingRecipes = recipes.unique()
            print("Ошибка при загрузке рецептов: \(error)")
        }
    }
    
    func fetchRecentRecipes() async {
        self.trendingRecipes = await dataService.fetchRecentRecipes()
       
        if trendingRecipes.isEmpty {
            self.trendingRecipes = recipes
        }
        self.trendingRecipes = self.trendingRecipes.unique()
    }
}
