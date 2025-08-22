//
//  SearchScreenViewModel.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//

import SwiftUI
import Combine

class SearchScreenViewModel: ObservableObject {
    private var networkService = NetworkServices.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchQuery: String = "How to"
    @Published var searchedRecipes: [Recipe] = []
    
    init() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    await self.fetchRecipes(query: query)
                }
            }
            .store(in: &cancellables)
        
        Task {
            await fetchRecipes(query: searchQuery)
        }
    }
    
    @MainActor
    func fetchRecipes(query: String) async {
        guard !query.isEmpty else {
            self.searchedRecipes = []
            return
        }
        
        do {
            let response = try await networkService.searchRecipes(query: query, numberOfResults: 30)
            self.searchedRecipes = response
            print("Recipes fetched for query: \(query)")
        } catch {
            print("Ошибка при загрузке рецептов: \(error)")
        }
    }
}
