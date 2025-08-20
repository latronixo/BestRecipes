//
//  RecipeView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct RecipeView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 20)
                Text("Recipe name")
                    .fontWeight(.semibold)
                    .font(.system(size: 25))
                Spacer(minLength: 230)
                
            }
            
            ZStack {
                if let img = detailVM.largeImage {
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .scaledToFit()
                } else {
                    
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .scaledToFit()
                        .foregroundStyle(.regularMaterial)

                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        
                }

                
            }
            
            HStack{
                Spacer(minLength: 20)
                Image(systemName: "star.fill")
                
                Text("4,5")
                Text("(300 Reviews)")
                Spacer(minLength: 210)
            }
            
        }
        .onAppear() {
            
        }
    }
    
}

#Preview {
    let viewModel = DetailViewModel(recipeId: Recipe.preview.id)
    RecipeView(detailVM: viewModel)
        .environmentObject(Router())
}
