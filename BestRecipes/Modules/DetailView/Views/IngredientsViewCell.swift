//
//  IngredientsView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI


struct IngredientsViewCell: View {
    
    @StateObject private var viewModel: IngredientCellViewModel
    @State private var isSelected = false
    
    init(ingredient: Ingredient) {
        _viewModel = StateObject(wrappedValue: IngredientCellViewModel(ingredient: ingredient))
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                //Фон для картинки
                Color(UIColor.systemGray6)
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                } else if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(15)
                } else {
                    Image(systemName: "fish.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(15)
                        .foregroundStyle(.regularMaterial)
                }
            }
            .frame(width: 52, height: 52)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(viewModel.ingredient.name.capitalized)
                .font(.poppinsSemibold(size: 16))
            
            Spacer()
            
            Text(String(format: "%.1f", viewModel.ingredient.amount))
                .font(.poppinsRegular(size: 14))
                .foregroundColor(.secondary)
            
            Text(viewModel.ingredient.unit)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(.secondary)

            Toggle("", isOn: $isSelected)
                .toggleStyle(CheckboxToggleStyle())
        }
        .padding()
        .background(
            Rectangle()
                .fill(Color.gray)
                .cornerRadius(20)
                .opacity(0.3)
                .shadow(color: .black, radius: 8, x:-2, y: 2)
        )
        .task {
            await viewModel.loadImage()
        }
    }
}

#Preview {
    IngredientsViewCell(ingredient: Recipe.preview.extendedIngredients!.first!)
        .padding()
}
