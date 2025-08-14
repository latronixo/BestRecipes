//
//  CookTimePickerView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//


import SwiftUI

struct CookTimePickerView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // MARK: - Title
                Text("Select cooking time")
                    .font(.poppinsSemibold(size: 20))
                    .padding(.top, 20)
                
                // MARK: - Picker
                Picker("Cook Time", selection: Binding(
                    get: { viewModel.recipe.cookTimeMinutes },
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Done") {
                    dismiss()
                }
            )
        }
    }
}

// MARK: - Preview
#Preview {
    CookTimePickerView(viewModel: AddRecipeViewModel())
}