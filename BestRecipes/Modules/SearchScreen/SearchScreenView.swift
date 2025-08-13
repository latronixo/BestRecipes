//
//  SearchScreenView.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 12/08/2025.
//

import SwiftUI

struct SearchScreenView: View {
    var categories = ["Salad", "Breakfast", "Appetizer", "Noodle", "Lunch"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                SearchBar()
                    .padding(.bottom)
            }
            VStack {
                ForEach(categories, id: \.self) {recipe in
                    SearchRecipe(recipe: recipe)
                }
            }
        }
        .padding(.leading)
        .padding(.top, 70)
        .padding(.bottom, 70)
    }
}

#Preview {
    SearchScreenView()
}
