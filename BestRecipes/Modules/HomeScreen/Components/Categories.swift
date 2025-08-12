//
//  Categories.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct Categories: View {
    var categories: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    Text(category)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            index == 0
                            ? Color.red.opacity(1)
                            : Color.clear
                        )
                        .foregroundColor(index == 0 ? .white : .red)
                        .cornerRadius(10)
                }
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    Categories(categories: ["Salad", "Breakfast", "Appetizer", "Noodle", "Lunch"])
}
