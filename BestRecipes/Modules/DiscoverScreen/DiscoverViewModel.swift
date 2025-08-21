//
//  DiscoverViewModel.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 20.08.2025.
//

import Foundation

@MainActor
final class DiscoverViewModel: ObservableObject {
    @Published var favorites: [Recipe] = []
    @Published var localSelectedTab: TabEnum = .bookmarks
    @Published var isLoading = false
    let coreData = CoreDataManager.shared
    
    // MARK: - Data
    func loadFavorites() async {
        isLoading = true
        let items = await coreData.fetchFavoriteRecipes()
        await MainActor.run {
            self.favorites = items
            self.isLoading = false
        }
    }
    
    func removeFromFavorites(_ recipe: Recipe) async {
        await coreData.toggleFavorite(recipe: recipe)
        await loadFavorites()
    }
}
