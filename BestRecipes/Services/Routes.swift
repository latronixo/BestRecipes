//
//  Routes.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import Foundation

enum Routes: Hashable{

    case homeScreen
    case detailScreen(recipeDetails: Recipe)
    case seeAllScreen(category: SeeAllCategory)
    case searchScreen
    case createScreen
    case profileScreen
    
}

enum SeeAllCategory: Hashable {
    case trending
    case recent
    case popularCuisine
    
    var title: String {
        switch self {
        case .trending:
            return "Trending now 🔥"
        case .recent:
            return "Recent recipe"
        case .popularCuisine:
            return "Popular cuisine"
        }
    }
}
