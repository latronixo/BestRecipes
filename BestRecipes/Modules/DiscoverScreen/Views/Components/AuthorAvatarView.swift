//
//  AuthorAvatarView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 20.08.2025.
//

import SwiftUI

struct AuthorAvatarView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image): image.resizable().scaledToFill()
            case .empty: Color.gray.opacity(0.2)
            case .failure: Image(systemName: "person.circle.fill").resizable().scaledToFill().foregroundStyle(.secondary)
            @unknown default: Color.gray.opacity(0.2)
            }
        }
        .frame(width: 32, height: 32)
        .clipShape(Circle())
    }
}

#Preview {
    AuthorAvatarView(url: URL(string: "https://zeeliciousfoods.com/favicon.ico"))
}
