//
//  MyRecipesView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI

struct MyRecipesView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            HStack {
                Text("My Recipes")
                    .font(.poppinsSemibold(size: 24))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding()
            
            
        }
    }
}

#Preview {
    MyRecipesView()
}
