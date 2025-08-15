//
//  RecipeParametersView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import SwiftUI

// MARK: - Recipe Parameters View
struct RecipeParametersView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    @State private var showingServingsPicker = false
    @State private var showingCookTimePicker = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            // MARK: - Servings Row
            GenericPickerView(
                title: "Serves",
                icon: "person.2.fill",
                selection: Binding(
                    get: { viewModel.recipe.servings },
                    set: { viewModel.updateServings($0) }
                ),
                options: viewModel.servingsOptions,
                valueFormatter: { String(format: "%02d", $0) },
                action: {
                    showingServingsPicker = true
                }
            )
            
            // MARK: - Cook Time Row
            GenericPickerView(
                title: "Cook time",
                icon: "clock.fill",
                selection: Binding(
                    get: { viewModel.recipe.readyInMinutes },
                    set: { viewModel.updateCookTime($0) }
                ),
                options: viewModel.cookTimeOptions,
                valueFormatter: { "\($0) min" },
                action: {
                    showingCookTimePicker = true
                }
            )
        }
        .sheet(isPresented: $showingServingsPicker) {
            GenericPickerSheet(
                title: "Select Servings",
                selection: Binding(
                    get: { viewModel.recipe.servings },
                    set: { viewModel.updateServings($0) }
                ),
                options: viewModel.servingsOptions,
                valueFormatter: { "\($0)" }
            )
        }
        .sheet(isPresented: $showingCookTimePicker) {
            GenericPickerSheet(
                title: "Select Cook Time",
                selection: Binding(
                    get: { viewModel.recipe.readyInMinutes },
                    set: { viewModel.updateCookTime($0) }
                ),
                options: viewModel.cookTimeOptions,
                valueFormatter: { "\($0) min" }
            )
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        RecipeParametersView(viewModel: AddRecipeViewModel())
        
        Spacer()
    }
    .padding()
}

