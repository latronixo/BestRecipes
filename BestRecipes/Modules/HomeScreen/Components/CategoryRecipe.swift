//
//  CategoryRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct CategoryRecipe: View {
    var recipe: String
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 8) {
                Spacer().frame(height: 50)

                Text(recipe)
                    .font(.headline)

                Text("Time")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                HStack() {
                    Text("5 mins")
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("Bookmark")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            .frame(width: 150)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

            Image("DishMock")
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .offset(y: -50)
        }
        .frame(width: 150)
        .padding(.trailing, 15)
    }
}

