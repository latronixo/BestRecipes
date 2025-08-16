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

    @State var isSelected = false
    
    init(detailVM: DetailViewModel, id: Int, text: String, weight: Double, unitShort: String, image: UIImage? = nil, isSelected: Bool = false) {
        self.detailVM = detailVM
        self.id = id
        self.text = text
        self.weight = weight
        self.unitShort = unitShort
        self.isSelected = isSelected
        
    }
    
    var body: some View {
        Spacer(minLength: 0)
        HStack {
            ZStack {
                
                if let image = searchImg() {
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
 
        .padding()
        Spacer(minLength: 10)
    }
    
    func searchImg() -> UIImage? {
        for ingredient in detailVM.ingredientsTuples {
            if ingredient.0.id == self.id {
                return ingredient.1
            }
        }
        return nil
    }
    
}



#Preview {
    IngredientsViewCell(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router(), instruction: [AnalyzedInstruction.preview]),
                        id: Recipe.preview.extendedIngredients.first!.id,
                        text: Recipe.preview.extendedIngredients.first!.name,
                        weight: Recipe.preview.extendedIngredients.first!.measures.metric.amount,
                        unitShort: Recipe.preview.extendedIngredients.first!.measures.metric.unitShort)
}
