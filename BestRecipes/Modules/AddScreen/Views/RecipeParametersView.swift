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
            RecipeParameterRow(
                icon: "person.2.fill",
                title: "Serves",
                value: viewModel.servingsDisplayValue(),
                action: {
                    showingServingsPicker = true
                }
            )
            
            // MARK: - Cook Time Row
            RecipeParameterRow(
                icon: "clock.fill",
                title: "Cook time",
                value: viewModel.cookTimeDisplayValue(),
                action: {
                    showingCookTimePicker = true
                }
            )
        }
        .sheet(isPresented: $showingServingsPicker) {
            ServingsPickerView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingCookTimePicker) {
            CookTimePickerView(viewModel: viewModel)
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
