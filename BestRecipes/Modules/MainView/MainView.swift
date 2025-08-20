//
//  MainView.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import SwiftUI



struct MainView: View {
    
    @StateObject private var router = Router()
    
    var body: some View {
        
        NavigationStack(path: $router.path) {
            CustomTabBar()
                    .navigationDestination(for: Routes.self) { route in
                        switch route {
                        case .homeScreen:
                            CustomTabBar()
                        case .detailScreen(recipeDetails: let recipeDetails):
                            DetailView(detailVM: DetailViewModel(recipe: recipeDetails, router: router))
                        case .seeAllScreen:
                            SeeAllView()
                        case .searchScreen:
                            SearchView()
                        case .createScreen:
                            AddRecipeView()
                        case .profileScreen:
                            PersonView()
                        }
                        
                    }
            }
            .environmentObject(router)
        
    }
}

#Preview {
    MainView()
}
