//
//  RecipeTextView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct RecipeTextView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            HStack {
                Text("Instruction")
                    .font(.system(size: 25, weight: .bold))
            }
            
            Spacer(minLength: 10)
            Text("""
                
                Place eggs in a saucepan and cover with cold water. Bring water to a boil and immediately remove from heat. Cover and let eggs stand in hot water for 10 to 12 minutes. Remove from hot water, cool, peel, and chop.
                 Place chopped eggs in a bowl.
                 Add chopped tomatoes, corns, lettuce, and any other vegitable of your choice.
                 Stir in mayonnaise, green onion, and mustard. Season with paprika, salt, and pepper.
                 Stir and serve on your favorite bread or crackers.
                """)
            .padding()
        }
    }
}

#Preview {
    RecipeTextView()
}
