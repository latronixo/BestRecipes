//
//  RecipeView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct RecipeView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 20)
                Text("Recipe name")
                    .fontWeight(.semibold)
                    .font(.system(size: 25))
                Spacer(minLength: 230)
                
            }
            Image(systemName: "photo.artframe")
                .resizable()
                .frame(width: 350, height: 350)
                .cornerRadius(40)
                .scaledToFit()
            HStack{
                Spacer(minLength: 20)
                Image(systemName: "star.fill")
                
                Text("4,5")
                Text("(300 Reviews)")
                Spacer(minLength: 210)
            }
            
        }
    }
}

#Preview {
    RecipeView()
}
