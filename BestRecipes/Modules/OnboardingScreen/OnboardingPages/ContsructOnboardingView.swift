//
//  ContsructOnboardingView.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI

struct ContsructOnboardingView: View {
    
    var enumConstraction: EnumConstructor
    let thirdScreen: Bool
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                Image("\(enumConstraction.backgroundImage)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 70) {
                Spacer()
                Group{
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
                        
                    case .second:
                        VStack(spacing: 8){
                            Text("Recipes with")
                                .foregroundStyle(.white)
                            Text("each and every")
                                .foregroundStyle(.green)
                            Text("detail")
                                .foregroundStyle(.green)
                        }
                        
                    case .third:
                        VStack(spacing: 8) {
                            Text("Cook it now or")
                                .foregroundStyle(.white)
                            Text("save it for later")
                                .foregroundStyle(.green)
                        }
                    }
                }
                .font(.system(size: 40))
                .fontWeight(.semibold)
                
                VStack(alignment: .center, spacing: 8){
                
                Button {
                    if currentPage < totalPages - 1{
                        currentPage += 1
                    }
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
                            currentPage = totalPages - 1
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
