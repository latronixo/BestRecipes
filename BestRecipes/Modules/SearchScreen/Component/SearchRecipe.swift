//
//  SearchRecipe.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//

import SwiftUI

struct SearchRecipe: View {
    var recipe: String
    var author: String {
        if recipe.localizedCaseInsensitiveContains("Foodista") == true {
            return "Foodista.com"
        } else {
            return recipe ?? ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .top) {
                
                Image("DishMock")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                VStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                        //Text(String(format: "%.2f", recipe.spoonacularScore))
                        Text("4.04")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Spacer()
                    
                    VStack {
                        Text(recipe)
                            .font(.poppinsSemibold(size: 16))
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("9 ingredients | 25 min")
                            .font(.poppinsRegular(size: 12))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    

                    
                }
            }
            
        }
        .frame(height: 200)
        .padding(.trailing, 10)
        .padding(.bottom)
    }
}
