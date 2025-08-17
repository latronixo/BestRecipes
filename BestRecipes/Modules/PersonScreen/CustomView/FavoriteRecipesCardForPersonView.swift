//
//  FavoriteRecipesCardForPersonView.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import SwiftUI

struct FavoriteRecipesCardForPersonView: View{
    var body: some View{
        ZStack {
            if #available(iOS 17.0, *) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.clear)
                    .stroke(.black, lineWidth: 1)
                    .frame(width: 343, height: 200)
                    .overlay {
                        //Use Image Recipe
                        Color.gray.opacity(0.3)
                            .frame(width: .infinity, height: .infinity)
                    }
            } else {
                // Fallback on earlier versions
            }
            
            VStack(alignment: .leading) {
                HStack{
                HStack(spacing: 6){
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundStyle(.black)
                        .frame(width: 16, height: 16)
                    
                    Text("5.0")
                        .font(.poppinsSemibold(size: 16))
                        .foregroundStyle(.gray)
                    
                }
                .background{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 58, height: 28)
                }
                    
                    Spacer()
                    
                    Button {
                        //Trash action
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .foregroundStyle(.black)
                            .frame(width: 20, height: 20)
                    }

                }
                .padding(.horizontal)
                
                VStack(spacing: 20){
                    VStack(spacing: 10) {
                        Text("First First First First First First First First First First First First")
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview{
    FavoriteRecipesCardForPersonView()
}
