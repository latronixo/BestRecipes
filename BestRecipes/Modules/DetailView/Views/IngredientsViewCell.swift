//
//  IngredientsView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI


struct IngredientsViewCell: View {
    
    @ObservedObject var detailVM: DetailViewModel
    
    @State var isSelected = false
    
    var body: some View {
        Spacer(minLength: 0)
        HStack {
            Spacer(minLength: 5)
            Image(systemName: "fish.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .clipped()
            Spacer()
            Text("Ingredients item name")
            Spacer(minLength: 50)
            Text("100 g")
            Spacer(minLength: 10)
            Toggle("", isOn: $isSelected)
                .toggleStyle(CheckboxToggleStyle())
            
            Spacer(minLength: 5)
        }
        .frame(height: 100)
        .background(
            Rectangle()
                .fill(Color.gray)
                .cornerRadius(20)
                .opacity(0.3)
                .shadow(color: .black, radius: 8, x:-2, y: 2)
        )
//        .background(Color.gray.opacity(0.1))
        .padding()
     Spacer(minLength: 0)
    }
}



#Preview {
    IngredientsViewCell(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router(), instruction: [AnalyzedInstruction.preview]))
}
