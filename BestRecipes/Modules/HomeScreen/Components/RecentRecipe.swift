//
//  RecentRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct RecentRecipe: View {
    var recipe: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image("DishMock")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(recipe)
                .fontWeight(.semibold)
                .lineLimit(2)

            Text("By Zeelicious Foods")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
        }
        .frame(width: 120)
        .padding(.trailing, 15)
    }
}

