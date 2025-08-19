//
//  SearchScreenViewModel.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//

import SwiftUI

class SearchScreenViewModel: ObservableObject {
    private var networkService = NetworkServices.shared
    @Published var searchQuery: String = ""
    @Published var searchedRecipes: [Recipe] = []
    
    let recipes = [
        Recipe.preview,
        Recipe.preview,
        Recipe.preview
    ]
    
    init() {
        Task {
            await fetchRecipes(query: searchQuery)
        }
    }
    
    func fetchRecipes(query: String) async {
        do {
            let response = try await networkService.searchRecipes(query: "pasta", numberOfResults: 30)
            self.searchedRecipes = response
            
            print("self.searchedRecipes")
        } catch {
            print("Ошибка при загрузке рецептов: \(error)")
        }
    }
}
