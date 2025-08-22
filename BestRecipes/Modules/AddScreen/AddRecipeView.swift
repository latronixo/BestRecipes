//
//  AddRecipeView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import SwiftUI

// MARK: - Add Recipe View
struct AddRecipeView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = AddRecipeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Recipe Image
                    RecipeImageView(viewModel: viewModel)
                    
                    // MARK: - Recipe Title
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Recipe title", text: Binding(
                            get: { viewModel.recipe.title },
                            set: { viewModel.updateTitle($0) }
                        ))
                        .font(.poppinsRegular(size: 18))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.red), lineWidth: 1)
                        )
                    }
                    
                    // MARK: - Recipe Parameters
                    RecipeParametersView(viewModel: viewModel)
                    
                    // MARK: - Ingredients
                    IngredientsView(viewModel: viewModel)
                    
                    // MARK: - Instructions
                    InstructionsView(viewModel: viewModel)
                    
                    // MARK: - Create Recipe Button
                    Button(action: {
                        Task {
                            await viewModel.createRecipe()
                        }
                    }) {
                        Text("Create recipe")
                            .font(.poppinsSemibold(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red)
                            )
                    }
                    .disabled(!viewModel.isFormValid)
                    .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Create recipe")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
            .alert("Notification", isPresented: $viewModel.showingAlert) {
                Button("OK") {
                    if viewModel.alertMessage.contains("successfully") {
                        dismiss()
                    }
                }
            } message: {
                Text(viewModel.alertMessage)
                    .font(.poppinsSemibold(size: 16))
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddRecipeView()
}
