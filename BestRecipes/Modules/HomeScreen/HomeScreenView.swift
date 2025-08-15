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
                .font(.poppinsSemibold(size: 24))
            
            SearchBar(text: $viewModel.text)
                .padding(.trailing)
            
            Heading(title: "Trending now 🔥")
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(viewModel.trendingRecipes) {recipe in
                        MainRecipe(recipe: recipe) { selectedRecipe in
                                viewModel.toggleFavourite(with: selectedRecipe)
                            }
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
                        ForEach(viewModel.categoryRecipes, id: \.self) {recipe in
                            CategoryRecipe(recipe: recipe)
                        }
                        .padding(.top, 70)
                    }
                }
                
            }
            
            // Recent recipe
            Heading(title: "Recent recipe")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.recentRecipes) {recipe in
                        RecentRecipe(recipe: recipe)
                    }
                }
            }
           
            Heading(title: "Popular cuisine")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.cuisineCountry, id: \.self) {country in
                        Country(country: country)
                    }
                }
                
            }
            
        }
        .padding(.leading)
        .padding(.top, 70)
        .padding(.bottom, 120)
    }
}
       
#Preview {
    HomeScreenView()
}
