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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                // Image
                AsyncImage(url: URL(string: recipe.image ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Color.red.opacity(0.2)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 180)
                .cornerRadius(16)
                .clipped()
                
                Text(formatTime(recipe.readyInMinutes))
                    .font(.system(size: 12, weight: .regular))
                    .frame(height: 25)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.black.opacity(0.12))
                            )
                    }
                    .cornerRadius(16)
                    .padding(8)
            }
            
            // Title
            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)
           
            // Additional info
            HStack(spacing: 8) {
                if let source = recipe.sourceName, !source.isEmpty {
                    // favicon (fallback — SF-иконка)
                    if let url = faviconURL() {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().scaledToFill()
                            case .empty:
                                Color.gray.opacity(0.2)
                            case .failure:
                                Image(systemName: "person.circle.fill")
                                    .resizable().scaledToFill()
                                    .foregroundStyle(.secondary)
                            @unknown default:
                                Color.gray.opacity(0.2)
                            }
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable().scaledToFill()
                            .foregroundStyle(.secondary)
                            .frame(width: 32, height: 32)
                    }
                    
                    Text("By \(source)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
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
}

#Preview {
    RecipeCardView(recipe: .preview)
}
