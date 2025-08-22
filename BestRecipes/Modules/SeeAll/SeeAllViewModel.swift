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
    @Published var trendingRecipes: [Recipe] = []

    let recipes = [
        Recipe.preview,
        Recipe.preview,
        Recipe.preview
    ]
    
    init() {
        Task {
            await fetchTrendingRecipes()
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
}
