//
//  RecipeTextView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct RecipeTextView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    @State var instruction: [AnalyzedInstruction]
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            HStack {
                Text("Instruction")
                    .font(.system(size: 25, weight: .bold))
            }
            
            Spacer(minLength: 10)
            HStack {
                Spacer(minLength: 10)
                Text(detailVM.makeInstructionsText(with: instruction))
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
        }
    }
}

#Preview {
    RecipeTextView(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router(), instruction: [AnalyzedInstruction.preview]), instruction: [AnalyzedInstruction.preview])
}
