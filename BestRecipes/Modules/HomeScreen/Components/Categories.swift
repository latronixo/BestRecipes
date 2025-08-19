//
//  Categories.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct Categories: View {
    var categories: [RecipeCategory]
    @Binding var selectedCategory: RecipeCategory
    var onSelect: (RecipeCategory) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories, id: \.self) { category in
                    Text(category.rawValue.capitalized)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            selectedCategory == category
                            ? Color.red
                            : Color.clear
                        )
                        .foregroundColor(selectedCategory == category ? .white : .red)
                        .font(.poppinsRegular(size: 12))
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedCategory = category
                            onSelect(category)
                        }
                }
            }
            .padding(.trailing)
        }
    }
}
