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
    @State var isFavor: Bool = false
    var recipeID: Int
    
    private var dataService = CoreDataManager.shared
    
    
    init(recipeID: Int) {
        self.recipeID = recipeID
//        Task {
//            
//            await self.checkFavorite()
//            
//        }
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
        }
    }
    
    mutating func checkFavorite() async {
        
        
        isFavor = await CoreDataManager.shared.isFavorite(id: recipeID)
        
    }
}

#Preview {
    FavoriteView(recipeID: Recipe.preview.id)
}
