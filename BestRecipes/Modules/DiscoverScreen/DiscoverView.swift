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
                        EmptyState()
                            .padding(.all, 16)
                            .padding(.bottom, tabBarHeight)
                    } else {
                        LazyVStack(spacing: 24) {
                            ForEach(favorites) { recipe in
                                RecipeCardView(recipe: recipe)
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.bottom, tabBarHeight)
                    }
                }
//                BottomTabBar(selectedTab: $localSelectedTab)
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


// MARK: - Empty state
private struct EmptyState: View {
    var body: some View {
        HStack(spacing: 12) {
            Image("BookmarkForCard")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("No saved recipes yet")
                .font(.poppinsRegular(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    DiscoverView(favorites: Array(repeating: .preview, count: 3))
}
