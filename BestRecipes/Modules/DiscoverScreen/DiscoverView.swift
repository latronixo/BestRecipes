//
//  DiscoverView.swift
//  BestRecipes
//
//  Created by Nadia on 12/08/2025.
//

import SwiftUI

// MARK: - DiscoverView (Saved recipes)
struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.favorites.isEmpty {
                    EmptyStateView()
                        .padding(.all, 16)
                        .padding(.bottom, 60)
                } else {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.favorites) { recipe in
                            let recipeCardVM = RecipeCardViewModel(
                                recipe: recipe,
                                isBookmarked: true
                            )
                            
                            RecipeCardView(onBookmarkTap: {
                                Task {
                                    await viewModel.removeFromFavorites(recipe)
                                }
                            })
                            .environmentObject(recipeCardVM)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.bottom, 84)
                }
            }
            .scrollIndicators(.hidden)
            if viewModel.isLoading {
                ProgressView().controlSize(.large)
            }
        }
        .task {
            if viewModel.favorites.isEmpty {
                await viewModel.loadFavorites()
            }
        }
        .refreshable {
            await viewModel.loadFavorites()
        } // pull-to-refresh
        .safeAreaInset(edge: .bottom) {
            BottomTabBar(selectedTab: $viewModel.localSelectedTab)
                .frame(height: 60)
                .background(.clear)
        }
    }
}

#Preview {
    DiscoverView()
}
