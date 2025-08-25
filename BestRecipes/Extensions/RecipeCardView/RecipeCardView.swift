//
//  RecipeCardView.swift
//  BestRecipes
//
//  Created by Nadia on 11/08/2025.
//

import SwiftUI

// MARK: - RecipeCardView
struct RecipeCardView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: RecipeCardViewModel
    var onBookmarkTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                // Image
                Button {
                    router.goTo(to: .detailScreen(recipe: viewModel.recipe))
                } label: {
                    AsyncImage(url: viewModel.imageURL) { phase in
                        switch phase {
                        case .empty: Color.gray.opacity(0.2)
                        case .success(let image): image.resizable().scaledToFill()
                        case .failure: Color.red.opacity(0.2)
                        @unknown default: EmptyView()
                        }
                    }
                    .frame(height: 180)
                    .cornerRadius(16)
                    .clipped()
                }
            }
            
            .overlay(alignment: .bottomTrailing) {
                TimePillView(text: viewModel.formatTime(viewModel.readyInMinutes))
                    .padding(8)
            }
            
            .overlay(alignment: .topTrailing) {
                BookmarkButtonView(
                    isBookmarked: viewModel.isBookmarked,
                    action: {
                        viewModel.toggleBookmark()
                        onBookmarkTap?()
                    }
                )
                .padding(8)
            }
            
            .overlay(alignment: .topLeading) {
                RatingBadgeView(rating: viewModel.formattedRating())
                    .padding(8)
            }
            
            // Title
            Text(viewModel.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundStyle(.text)
           
            // Additional info
            if let source = viewModel.sourceName, !source.isEmpty {
                    HStack(spacing: 8) {
                        AuthorAvatarView(url: viewModel.faviconURL)
                        Text("By \(source)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let mockRecipe = Recipe(
        id: 1,
        title: "Sample Recipe",
        readyInMinutes: 45,
        servings: 4,
        vegetarian: false,
        vegan: false,
        glutenFree: true,
        dairyFree: false,
        veryHealthy: true,
        cheap: false,
        veryPopular: true,
        sustainable: false,
        lowFodmap: false
    )
    
    let mockViewModel = RecipeCardViewModel(recipe: mockRecipe, isBookmarked: true)
    
    return RecipeCardView()
        .environmentObject(mockViewModel)
}
