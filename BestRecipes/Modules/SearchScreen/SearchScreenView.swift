//
//  SearchScreenView.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//
import SwiftUI



struct SearchScreenView: View {
    @StateObject private var viewModel = SearchScreenViewModel()
    
    let recipes = [
        Recipe.preview,
        Recipe.preview
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                
                SearchBar(text: $viewModel.searchQuery)
                    .zIndex(1)
                
                ForEach(recipes, id: \.id) { recipe in
                    SearchRecipe(recipe: recipe)
                }
            }
            .padding(.horizontal)
            .padding(.top, 70)
        }
    }
}


#Preview {
    SearchScreenView()
}
