//
//  ContentView.swift
//  BestRecipes
//
//  Created by Валентин on 10.08.2025.
//

import SwiftUI

// MARK: - ContentView
struct HomeScreenView: View {
    @ObservedObject var viewModel = HomeScreenViewModel()
    var categories = ["Salad", "Breakfast", "Appetizer", "Noodle", "Lunch"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Get amazing recipes for cooking")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)
                .font(.title)
            
            SearchBar()
            
            Heading(title: "Trending now 🔥")
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(viewModel.trendingRecipes) {recipe in
                        MainRecipe(recipe: recipe)
                    }
                }
            }
            
            // Popular category
            VStack {
                Text("Popular category")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .font(.title2)
                
                Categories(categories: viewModel.mealTypes)
                
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
        .padding(.leading)
        .padding(.top, 70)
        .padding(.bottom, 70)
    }
}
       
#Preview {
    HomeScreenView()
}
