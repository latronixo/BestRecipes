//
//  ContsructOnboardingView.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI

struct ContsructOnboardingView: View {
    
    var enumConstraction: EnumConstructor
    let whiteText: String
    let greenText: String
    let thirdScreen: Bool
    
    var body: some View {
        ZStack{
            Image("\(enumConstraction.backgroundImage)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                
                switch enumConstraction {
                case .first:
                    VStack(spacing: 8) {
                        Text("Recipes from")
                            .foregroundStyle(.white)
                        HStack {
                            Text("all")
                                .foregroundStyle(.white)
                            
                            Text("over the")
                                .foregroundStyle(.green)
                        }
                        
                        Text("World")
                            .foregroundStyle(.green)
                        
                    }
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    
                case .second:
                    VStack(spacing: 8){
                        Text("Recipes with")
                            .foregroundStyle(.white)
                        Text("each and every detail")
                            .foregroundStyle(.green)
                    }
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    
                case .third:
                    VStack(spacing: 8) {
                        Text("Cook it now or")
                            .foregroundStyle(.white)
                        Text("save it for later")
                            .foregroundStyle(.green)
                    }
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                }
                
                VStack(alignment: .center, spacing: 8){
                
                Button {
                    
                } label: {
                    Text(thirdScreen ? "Start Cooking" : "Continue")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.white)
                    .bold()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red.opacity(0.6))
                            .frame(width: 300, height: 50)
                    }
                    .padding()
                }
                
                    if thirdScreen == false {
                        Button {
                            
                        } label: {
                            Text("Skip")
                                .fontWeight(.light)
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 15)
                        }
                        
                    }
                }

                
            }
            .padding()
            
        }
    }
}

#Preview {
    ContsructOnboardingView(enumConstraction: .first, whiteText: "Recipes for all", greenText: "over the World", thirdScreen: false)
}
