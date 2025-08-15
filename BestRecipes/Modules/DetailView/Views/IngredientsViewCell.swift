//
//  IngredientsView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI


struct IngredientsViewCell: View {
    
    @ObservedObject var detailVM: DetailViewModel
    //    @State var ingredient: Ingredient
    @State var id: Int
    @State var text: String
    @State var weight: Double
    @State var unitShort: String
    @State var image: UIImage?
    
    @State var isSelected = false
    
    var body: some View {
        Spacer(minLength: 0)
        HStack {
            ZStack {
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(15)
                        .scaledToFit()
                } else {
                    Image(systemName: "fish.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(15)
                        .scaledToFit()
                        .foregroundStyle(.regularMaterial)
                        .task {
                            await detailVM.fetchIngredients()
                            for ingredient in detailVM.ingredientsTuples {
                                if ingredient.0.id == self.id {
                                    self.image = ingredient.1
                                }
                            }
                        }
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                }
            }
            
            
            Spacer()
            Text(text)
            Spacer(minLength: 50)
            Text(String(weight))
            Text(unitShort + "  ")
            Toggle("", isOn: $isSelected)
                .toggleStyle(CheckboxToggleStyle())
            
//            Spacer(minLength: 5)
        }
        .padding([.leading, .trailing], 5)
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
        Spacer(minLength: 10)
    }
}



#Preview {
    IngredientsViewCell(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router(), instruction: [AnalyzedInstruction.preview]),
                        id: Recipe.preview.extendedIngredients.first!.id,
                        text: Recipe.preview.extendedIngredients.first!.name,
                        weight: Recipe.preview.extendedIngredients.first!.measures.metric.amount,
                        unitShort: Recipe.preview.extendedIngredients.first!.measures.metric.unitShort)
}
