//
//  TabEnum.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI


enum TabEnum: Int, CaseIterable {
    case home, bookmarks, add, notifications, profile
    
    var icon: String {
        switch self {
        case .home: return "home"
        case .bookmarks: return "bookmarkIconForTabBar"
        case .add: return "plus"
        case .notifications: return "bell"
        case .profile: return "person"
        }
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .home: HomeScreenView()
        case .bookmarks: DiscoverView(favorites: Array(repeating: .preview, count: 3))
        case .add: AddRecipeView()
        case .notifications: BellView()
        case .profile: PersonView()
        }
    }
}
