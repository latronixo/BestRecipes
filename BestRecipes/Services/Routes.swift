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
    case seeAllScreen
    case searchScreen
    case createScreen
    case profileScreen
    
}
