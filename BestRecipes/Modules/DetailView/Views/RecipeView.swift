//
//  RecipeView.swift
//  BestRecipes
//
//  Created by Sergey on 11.08.2025.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct RecipeView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    let coreData = CoreDataManager.shared
    
    
    @State var darkFavIcon = "BookmarkForCard"
    @State var activeFavIcon = "BookmarkActive"
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 20)
                Text(detailVM.recipe.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 25))
                Spacer(minLength: 15)
                
            }
            
            ZStack {
                if let img = detailVM.largeImage {
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .scaledToFit()
                        .shadow(color: .black, radius: 8, x:-2, y: 2)
                    
                } else {
                    
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .cornerRadius(40)
                        .scaledToFit()
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 8, x:-2, y: 2)

                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                }

                ZStack() {
                    
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                    Image(detailVM.isFavorite ? activeFavIcon : darkFavIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                }
                .onTapGesture {
                    detailVM.isFavorite.toggle()
                    Task {
                        await self.coreData.toggleFavorite(recipe: detailVM.recipe)
                    }
                    
                }
                    .offset(x: 130, y:-130)
                    
                    
                
            }
            
            
            HStack{
                Spacer(minLength: 15)
                Image(systemName: "star.fill")
                
                Text(String(format: "%.1f", (detailVM.recipe.spoonacularScore ?? 0.0) /  20.0))
                Text(String("(\(detailVM.recipe.aggregateLikes ?? 0) Reviews)"))
                Spacer(minLength: 210)
            }
            HStack {
                Spacer(minLength: 200)
                Image(systemName: "person.2")
                    .resizable()
                    .frame(width: 35, height: 30)
                Text("  \(detailVM.recipe.servings)")
                    .font(.system(size: 20,weight: .semibold))
                Spacer(minLength: 1)
                Image(systemName: "alarm")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("  \(detailVM.recipe.readyInMinutes) min")
                    .font(.system(size: 20,weight: .semibold))
                Spacer(minLength: 15)
            }
            TagListView(tags: detailVM.tags)
               
            
            switch detailVM.tags.count {
            case 0...3 :
                Spacer(minLength: 50)
            case 4...7 :
                Spacer(minLength: 90)
            case 8...11 :
                Spacer(minLength: 130)
            case 12...15 :
                Spacer(minLength: 170)
            case 16...19 :
                Spacer(minLength: 210)
            default :
                Spacer(minLength: 30)
            }
                
        }
        
        
    }
    

    
}

#Preview {
    RecipeView(detailVM: DetailViewModel(recipe: Recipe.preview, router: Router()))
}
