//
//  RecipeCardView.swift
//  BestRecipes
//
//  Created by Nadia on 11/08/2025.
//

import SwiftUI

// MARK: - RecipeCardView
struct RecipeCardView: View {
    let recipe: Recipe
    var isBookmarked = false
    var onBookmarkTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                // Image
                AsyncImage(url: URL(string: recipe.image ?? "")) { phase in
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
            
            .overlay(alignment: .bottomTrailing) {
                TimePillView(text: formatTime(recipe.readyInMinutes))
                    .padding(8)
            }
            
            .overlay(alignment: .topTrailing) {
                BookmarkButtonView(isBookmarked: isBookmarked, action: onBookmarkTap)
                    .padding(8)
            }
            
            .overlay(alignment: .topLeading) {
                RatingBadgeView(rating: formattedRating())
                    .padding(8)
            }
            
            // Title
            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)
           
            // Additional info
                if let source = recipe.sourceName, !source.isEmpty {
                    HStack(spacing: 8) {
                        AuthorAvatarView(url: faviconURL())
                        Text("By \(source)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return String(format: "%02d:%02d", h, m)
    }
    
    private func faviconURL() -> URL? {
        // try sourceUrl, then spoonacularSourceUrl
        let candidates = [recipe.sourceUrl, recipe.spoonacularSourceUrl]
        for link in candidates {
            if let link, let pageURL = URL(string: link), let host = pageURL.host {
                // Google S2
                if let url = URL(string: "https://www.google.com/s2/favicons?domain=\(host)&sz=64") {
                    return url
                }
                // favicon.ico
                if let url = URL(string: "https://\(host)/favicon.ico") {
                    return url
                }
            }
        }
        return nil
    }
    
    private func formattedRating() -> String {
        let score = recipe.spoonacularScore ?? 100
        let fiveScale = max(0, min(5, score / 20.0))
        return String(format: "%.1f", fiveScale).replacingOccurrences(of: ".", with: ",")
    }
}

#Preview {
    RecipeCardView(recipe: .preview)
}
