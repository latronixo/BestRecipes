//
//  Router.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import Foundation
import SwiftUI


class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func goTo(to route: Routes) {
        path.append(route)
    }
    
    func goBack() {
    
        if path.isEmpty { return }
        path.removeLast()
        
    }
    
    func goToRoot() {
        path.removeLast(path.count)
    }
    
    func popToView(count: Int) {
        path.removeLast(count)
    }
    
    
    
}

enum Routes: Hashable {

    case homeScreen
    case detailScreen(recipe: Recipe)
    case seeAllScreen(category: SeeAllCategory)
    case searchScreen
    case createScreen
    case profileScreen
    
}

enum SeeAllCategory: Hashable {
    case trending
    case recent
    case popularCuisine
    case byPopularCuisine(CuisineType)
    
    var title: String {
        switch self {
        case .trending:
            return "Trending now 🔥"
        case .recent:
            return "Recent recipe"
        case .popularCuisine:
            return "Popular cuisine"
        case .byPopularCuisine(let cuisine):
            return "Popular \(cuisine.rawValue.capitalized) cuisine"
        }
    }
}
