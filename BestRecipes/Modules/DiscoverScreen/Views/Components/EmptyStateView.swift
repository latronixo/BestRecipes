//
//  EmptyState.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 20.08.2025.
//


import SwiftUI

struct EmptyStateView: View {
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
    EmptyStateView()
}
