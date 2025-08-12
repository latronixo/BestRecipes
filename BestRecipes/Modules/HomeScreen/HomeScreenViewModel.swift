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
    @Published var trendingRecipes: [Recipe] = []
    
    init() {
        Task {
            await fetchTrendingRecipes()
        }
    }
    
    func fetchTrendingRecipes() async {
        do {
            let response = try await networkService.fetchRandomRecipes(numberOfRecipes: 10)
            self.trendingRecipes = response.recipes
            print(self.trendingRecipes.count)
        } catch {
            print("Ошибка при загрузке рецептов: \(error)")
        }
    }
}




