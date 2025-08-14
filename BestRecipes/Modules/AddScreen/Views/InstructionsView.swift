//
//  InstructionsView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import SwiftUI

// MARK: - Instructions View
struct InstructionsView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header
            Text("Instructions")
                .font(.poppinsSemibold(size: 20))
                .foregroundColor(.black)
            
            // MARK: - Instructions Text Editor
            TextEditor(text: Binding(
                get: { viewModel.recipe.instructions },
                set: { viewModel.updateInstructions($0) }
            ))
            .font(.poppinsRegular(size: 16))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .frame(minHeight: 120)
            .overlay(
                Group {
                    if viewModel.recipe.instructions.isEmpty {
                        VStack {
                            HStack {
                                Text("Describe the cooking process...")
                                    .font(.poppinsRegular(size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 16)
                                    .padding(.top, 20)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            )
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        InstructionsView(viewModel: AddRecipeViewModel())
        
        Spacer()
    }
    .padding()
}
