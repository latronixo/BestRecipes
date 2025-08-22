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
        case .profile: return "profile"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Get amazing recipes for cooking"
        case .bookmarks:
            return "Saved recipes"
        case .add:
            return "Create recipe"
        case .notifications:
            return "Notifications"
        case .profile:
            return "My profile"
        }
    }
}
