//
//  InstructionsView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//

import SwiftUI

struct InstructionsView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header
            Text("Instructions")
                .font(.poppinsSemibold(size: 18))
            
            // MARK: - Instructions Text Editor
            VStack(alignment: .leading, spacing: 8) {
                TextEditor(text: Binding(
                    get: { viewModel.recipe.instructions ?? "" },
                    set: { viewModel.updateInstructions($0) }
                ))
                .font(.poppinsRegular(size: 16))
                .frame(minHeight: 120)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                
                // MARK: - Placeholder
                if (viewModel.recipe.instructions?.isEmpty ?? true) {
                    HStack {
                        Text("Describe the cooking process...")
                            .font(.poppinsRegular(size: 16))
                            .foregroundColor(.gray)
                            .padding(.leading, 16)
                            .padding(.top, 20)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview
#Preview {
    InstructionsView(viewModel: AddRecipeViewModel())
        .background(Color(.systemBackground))
}
