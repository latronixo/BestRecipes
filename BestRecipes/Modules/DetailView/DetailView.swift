//
//  DetailView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    
    init(detailVM: DetailViewModel) {
        
        self.detailVM = detailVM
        
    }
    
    
    var body: some View {
        NavigationStack{
            
            
            VStack {
                ScrollView {
                    RecipeView()
                    RecipeTextView(detailVM: detailVM, instruction: detailVM.instruction)
                    
                    ForEach(0..<5) { _ in
                        IngredientsViewCell()
                        
                    }
                    
                }
            }
            .navigationTitle("Recipe Detail")
             
        }
    }
    
  
    
}

#Preview {
    DetailView(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router(), instruction: [AnalyzedInstruction.preview]))
}
