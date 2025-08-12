//
//  MainRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct MainRecipe: View {
    var recipe: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .top) {
                Image("DishMock")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                        Text("4.6")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image("Bookmark")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                
            }
            Text(recipe)
                .fontWeight(.semibold)
                .lineLimit(2)

            HStack {
                Image("DishMock")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                Text("By Zeelicious Foods")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            

            Spacer()
        }
        .frame(width: 300)
        .padding(.trailing, 10)
    }
}

