//
//  MyRecipesView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI

struct MyRecipesView: View {
    @State private var myRecipes: [MyRecipeCD] = []
    @State private var isLoading = false
    @State private var showDeleteAlert = false
    @State private var recipeToDelete: MyRecipeCD?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("My Recipes")
                    .font(.poppinsSemibold(size: 24))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            
            if isLoading {
                ProgressView()
            } else if myRecipes.isEmpty {
                Text("No recipes yet")
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(myRecipes, id: \.self) { recipe in
                            FavoriteRecipesCardForPersonView(recipe: recipe)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        recipeToDelete = recipe
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .alert("Delete Recipe", isPresented: $showDeleteAlert, presenting: recipeToDelete) { recipe in
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    await CoreDataManager.shared.deleteMyRecipe(id: Int(Int64(recipeToDelete?.id ?? 0)))
                }
            }
        } message: { recipe in
            Text("Are you sure you want to delete \(recipe.title ?? "this recipe")?")
        }
        .onAppear {
            Task{
                await CoreDataManager.shared.fetchMyRecipes()
                print(myRecipes.count)
            }
        }
    }
}
