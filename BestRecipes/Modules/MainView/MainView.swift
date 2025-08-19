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
                            ContentView()
                        case .detailScreen(recipeDetails: let recipeDetails):
                            DetailView(detailVM: DetailViewModel(recipe: recipeDetails, router: router))
                        case .seeAllScreen(let category):
                            SeeAllView(category: category)
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
