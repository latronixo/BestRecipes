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
    //@State private var refreshID = UUID()
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("My Recipes")
                    .font(.poppinsSemibold(size: 24))
                    .foregroundStyle(.primary)
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
                    LazyVStack(spacing: 16) {
                        ForEach(myRecipes, id: \.id) { recipe in
                            Button {
                                router.goTo(to: .detailScreen(recipe: recipe))
                            } label: {
                                FavoriteRecipesCardForProfileView(
                                    recipe: recipe,
                                    onDelete: {
                                        recipeToDelete = recipe
                                        showDeleteAlert = true
                                    }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .alert("Delete Recipe", isPresented: $showDeleteAlert, presenting: recipeToDelete) { recipe in
            Button("Cancel", role: .cancel) {}.tint(.secondary)
            Button("Delete", role: .destructive) {
                Task {
                    await CoreDataManager.shared.deleteMyRecipe(id: Int(Int64(recipeToDelete?.id ?? 0)))
                }
            }
        } message: { recipe in
            Text("Are you sure you want to delete \(recipe.title)?")
        }
        .onAppear {
            Task{
                myRecipes = await CoreDataManager.shared.fetchMyRecipes()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)) { _ in
            Task {
                myRecipes = await CoreDataManager.shared.fetchMyRecipes()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyRecipesView()
            .environmentObject(Router())
    }
}
