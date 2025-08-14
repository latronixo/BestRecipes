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
            ServingsPickerSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $showingCookTimePicker) {
            CookTimePickerSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Servings Picker Sheet
struct ServingsPickerSheet: View {
    @ObservedObject var viewModel: AddRecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Servings")
                    .font(.poppinsSemibold(size: 20))
                    .padding(.top, 20)
                
                Picker("Servings", selection: Binding(
                    get: { viewModel.recipe.servings },
                    set: { viewModel.updateServings($0) }
                )) {
                    ForEach(viewModel.servingsOptions, id: \.self) { servings in
                        Text("\(servings)")
                            .font(.poppinsRegular(size: 18))
                            .tag(servings)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Spacer()
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
                .font(.poppinsSemibold(size: 16))
            )
        }
    }
}

// MARK: - Cook Time Picker Sheet
struct CookTimePickerSheet: View {
    @ObservedObject var viewModel: AddRecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Cook Time")
                    .font(.poppinsSemibold(size: 20))
                    .padding(.top, 20)
                
                Picker("Cook Time", selection: Binding(
                    get: { viewModel.recipe.readyInMinutes },
                    set: { viewModel.updateCookTime($0) }
                )) {
                    ForEach(viewModel.cookTimeOptions, id: \.self) { minutes in
                        Text("\(minutes) min")
                            .font(.poppinsRegular(size: 18))
                            .tag(minutes)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Spacer()
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
                .font(.poppinsSemibold(size: 16))
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
