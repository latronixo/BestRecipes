//
//  MyRecipesView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI

struct MyRecipesView: View {
    @State private var myRecipes: [Recipe] = []
    @State private var isLoading = false
    @State private var showDeleteAlert = false
    @State private var recipeToDelete: Recipe?
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("My Recipes")
                .font(.poppinsSemibold(size: 24))
                .foregroundStyle(.black)
                .padding(.horizontal, 30)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if myRecipes.isEmpty {
                Text("Not recipes add")
                    .padding(.horizontal, 30)
            } else {
                    VStack(spacing: 20) {
                        ForEach(myRecipes, id: \.id) { recipe in // Используем явный id
                            MyRecipesRow(recipe: recipe)
                                .padding(.horizontal, 4)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        recipeToDelete = recipe
                                        showDeleteAlert = true
                                        
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    router.goTo(to: .detailScreen(recipe: recipe))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
        }
        .alert("Delete Recipe", isPresented: $showDeleteAlert, presenting: recipeToDelete) { recipe in
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteRecipe(recipe)
            }
        } message: { recipe in
            Text("Are you sure you want to delete \"\(recipe.title)\"?")
        }
        .task {
            await loadRecipes()
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)) { _ in
            Task {
                await loadRecipes()
            }
        }
    }
    
    private func loadRecipes() async {
        isLoading = true
        myRecipes = await CoreDataManager.shared.fetchMyRecipes()
        isLoading = false
    }
    
    private func deleteRecipe(_ recipe: Recipe) {
        Task {
            await CoreDataManager.shared.deleteMyRecipe(id: Int(recipe.id))
            await loadRecipes()
        }
    }
}
