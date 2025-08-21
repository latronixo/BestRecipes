//
//  FavoriteView.swift
//  BestRecipes
//
//  Created by Sergey on 19.08.2025.
//

import SwiftUI

struct FavoriteView: View {
    @State var darkFavIcon = "BookmarkForCard"
    @State var activeFavIcon = "BookmarkActive"
    @State var isFavor: Bool
    @State var recipe: Recipe
    private var coreDataManager = CoreDataManager.shared
    
    init(isFavor: Bool, recipe: Recipe) {
        self.isFavor = isFavor
        self.recipe = recipe
    }
    
    
    var body: some View {
        ZStack() {
            
            Circle()
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: 50, height: 50)
            Image(isFavor ? activeFavIcon : darkFavIcon)
                .resizable()
                .frame(width: 40, height: 40)
            
        }
        .onTapGesture {
            isFavor.toggle()
            Task {
                await self.coreDataManager.toggleFavorite(recipe: recipe)
            }
            
        }
    }
    

}

#Preview {
    FavoriteView(isFavor: true, recipe: Recipe.preview)
}
