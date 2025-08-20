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
    
    
    init(isFavor: Bool) {
        self.isFavor = isFavor

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
    

}

#Preview {
    FavoriteView(isFavor: true)
}
