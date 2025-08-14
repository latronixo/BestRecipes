//
//  ServingsPickerView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//


import SwiftUI

struct ServingsPickerView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // MARK: - Title
                Text("Select number of servings")
                    .font(.poppinsSemibold(size: 20))
                    .padding(.top, 20)
                
                // MARK: - Picker
                Picker("Servings", selection: Binding(
                    get: { viewModel.recipe.servings },
                    set: { viewModel.updateServings($0) }
                )) {
                    ForEach(viewModel.servingsOptions, id: \.self) { serving in
                        Text("\(serving)")
                            .font(.poppinsRegular(size: 18))
                            .tag(serving)
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
    ServingsPickerView(viewModel: AddRecipeViewModel())
}