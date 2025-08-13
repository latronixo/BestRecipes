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
        
        VStack(alignment: .center, spacing: 40) {
            Spacer()
            Group{
                switch enumConstraction {
                case .first:
                    VStack(spacing: 2) {
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
                    VStack(spacing: 2){
                        Text("Recipes with")
                            .foregroundStyle(.white)
                        Text("each and every")
                            .foregroundStyle(.green)
                        Text("detail")
                            .foregroundStyle(.green)
                    }
                    
                case .third:
                    VStack(spacing: 2) {
                        Text("Cook it now or")
                            .foregroundStyle(.white)
                        Text("save it for later")
                            .foregroundStyle(.green)
                    }
                }
            }
            .font(.poppinsSemibold(size: 40))
            
            VStack(alignment: .center, spacing: 8){
                
                Button {
                    if currentPage < totalPages - 1{
                        currentPage += 1
                    }
                } label: {
                    Text(thirdScreen ? "Start Cooking" : "Continue")
                        .font(.poppinsRegular(size: 18))
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
            
            .padding(.bottom, 40)
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}

