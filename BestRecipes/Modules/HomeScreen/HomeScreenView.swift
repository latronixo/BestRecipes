//
//  ContentView.swift
//  BestRecipes
//
//  Created by Валентин on 10.08.2025.
//

import SwiftUI

// MARK: - ContentView
struct HomeScreenView: View {
    
    var categories = ["Salad", "Breakfast", "Appetizer", "Noodle", "Lunch"]
    
    var body: some View {
        ScrollView() {
            Text("Get amazing recipes for cooking")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)
                .font(.title)
            
            SearchBar()
            
            Heading(title: "Trending now 🔥")
            
            // Popular category
            VStack {
                Text("Popular category")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .font(.title2)
                
                Categories(categories: categories)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) {recipe in
                            CategoryRecipe(recipe: recipe)
                        }
                        .padding(.top, 70)
                    }
                }
                
            }
            
            Heading(title: "Recent recipe")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) {recipe in
                        RecentRecipe(recipe: recipe)
                    }
                }
            }
           
            Heading(title: "Popular cuisine")
            
        }
        .padding(.horizontal)
        .padding(.top, 70)
    }
}
       
#Preview {
    HomeScreenView()
}
