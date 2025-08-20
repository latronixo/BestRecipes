//
//  DiscoverView.swift
//  BestRecipes
//
//  Created by Nadia on 12/08/2025.
//

import SwiftUI

// MARK: - DiscoverView (Saved recipes)
struct DiscoverView: View {
    @State private var favorites: [Recipe] = []
    @State private var isLoading = false
    @State private var localSelectedTab: TabEnum = .bookmarks
    
    private let tabBarHeight: CGFloat = 60

    // allow injection for previews
    init(favorites: [Recipe] = []) {
        _favorites = State(initialValue: favorites)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    if favorites.isEmpty {
                        EmptyStateView()
                            .padding(.all, 16)
                            .padding(.bottom, tabBarHeight)
                    } else {
                        LazyVStack(spacing: 24) {
                            ForEach(favorites) { recipe in
                                RecipeCardView(
                                    recipe: recipe,
                                    isBookmarked: true,
                                    onBookmarkTap: {}
                                )
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.bottom, tabBarHeight + 24)
                    }
                }
                .scrollIndicators(.hidden)
                
                if isLoading {
                    ProgressView().controlSize(.large)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Saved recipes")
                        .font(.poppinsSemibold(size: 24))
                }
            }
            .task { if favorites.isEmpty { await loadFavorites() } }
            .refreshable { await loadFavorites() } // pull-to-refresh
            .safeAreaInset(edge: .bottom) {
                BottomTabBar(selectedTab: $localSelectedTab)
                    .frame(height: tabBarHeight)
                    .background(.clear)
            }
        }
    }
    
    // MARK: - Data
    private func loadFavorites() async {
        isLoading = true
        let items = await CoreDataManager.shared.fetchFavoriteRecipes()
        await MainActor.run {
            self.favorites = items
            self.isLoading = false
        }
    }
}

#Preview {
    DiscoverView(favorites: Array(repeating: .preview, count: 3))
}
