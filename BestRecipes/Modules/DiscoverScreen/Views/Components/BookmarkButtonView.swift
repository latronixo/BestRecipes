//
//  BookmarkButtonView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 20.08.2025.
//

import SwiftUI

struct BookmarkButtonView: View {
    let isBookmarked: Bool
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: { action?() }) {
            Group {
                let image = isBookmarked
                ? Image("BookmarkActive")
                : Image("BookmarkForCard")
                image
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 28, height: 28)
            .padding(10)
            .background(.ultraThinMaterial.opacity(0.95))
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BookmarkButtonView(isBookmarked: true)
}
