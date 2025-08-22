//
//  SearchScreenView.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//
import SwiftUI



struct SearchScreenView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = SearchScreenViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                
                SearchBar(
                    text: $viewModel.searchQuery,
                    onClose: {
                        dismiss()
                    }
                )
                .zIndex(1)
                
                ForEach(viewModel.searchedRecipes) { recipe in
                    Button {
                        router.goTo(to: .detailScreen(recipeId: recipe.id))
                    } label: {
                        SearchRecipe(recipe: recipe)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .toolbar(.hidden)
        }
    }
}




#Preview {
    SearchScreenView()
}
