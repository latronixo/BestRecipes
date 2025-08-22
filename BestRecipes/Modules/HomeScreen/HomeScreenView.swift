//
//  ContentView.swift
//  BestRecipes
//
//  Created by Валентин on 10.08.2025.
//

import SwiftUI



// MARK: - ContentView
struct HomeScreenView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = HomeScreenViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Get amazing recipes for cooking")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)
                .font(.poppinsSemibold(size: 24))
            
            SearchBar(text: .constant(""))
                .padding(.trailing)
                .disabled(true)
                .contentShape(Rectangle())
                .onTapGesture {
                    router.goTo(to: .searchScreen)
                }
            
            Heading(title: "Trending now 🔥") {
                router.goTo(to: .seeAllScreen(category: .trending))
            }
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(viewModel.trendingRecipes) {recipe in
                        Button {
                            router.goTo(to: .detailScreen(recipeId: recipe.id))
                        } label: {
                            MainRecipe(recipe: recipe) { selectedRecipe in
                                Task {
                                    await viewModel.toggleFavourite(with: selectedRecipe)
                                }
                            }
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
                
                Categories(
                    categories: RecipeCategory.allCases,
                    selectedCategory: $viewModel.currentCategory
                ) { category in
                    Task {
                        await viewModel.fetchCategoryRecipes(category: category)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.categoryRecipes) {recipe in
                            Button {
                                router.goTo(to: .detailScreen(recipeId: recipe.id))
                            } label: {
                                CategoryRecipe(recipe: recipe) { selectedRecipe in
                                    Task {
                                        await viewModel.toggleFavourite(with: selectedRecipe)
                                    }
                                }
                            }
                        }
                        .padding(.top, 70)
                    }
                }
                
            }
            
            // Recent recipe
            Heading(title: "Recent recipe") {
                router.goTo(to: .seeAllScreen(category: .recent))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.recentRecipes, id: \.id) {recipe in
                        Button {
                            router.goTo(to: .detailScreen(recipeId: recipe.id))
                        } label: {
                            RecentRecipe(recipe: recipe)
                        }
                    }
                }
            }
           
            Heading(title: "Popular cuisine") {
                router.goTo(to: .seeAllScreen(category: .popularCuisine))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.cuisineCountry, id: \.self) {country in
                        Country(country: country)
                    }
                }
            }
            .padding(.top)
            .padding(.bottom, 50)
            
        }
        .padding(.leading)
        .task {
            await viewModel.fetchRecentRecipes()
        }
    }
}

#Preview {
    HomeScreenView()
}
