//
//  DetailViewModel.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import Foundation
import Combine
import SwiftUI

final class DetailViewModel: ObservableObject {
    
    @Published var recipe: Recipe
    private let router: Router
    
    init(recipe: Recipe, router: Router) {
        
        self.recipe = recipe
        self.router = router
    }
    
    func goHome() {
        router.goTo(to: .homeScreen)
    }
    
}
