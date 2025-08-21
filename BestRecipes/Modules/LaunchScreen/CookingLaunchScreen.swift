//
//  CookingLaunchScreen.swift
//  BestRecipes
//
//  Created by Drolllted on 21.08.2025.
//

import SwiftUI
import Lottie

struct CookingLaunchScreen: View {
    @State private var showText = false
    
    var body: some View {
        ZStack {
            // Фон
            Image("backOnboardingImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 30) {
                // Lottie анимация
                LottieView(animation: .named("cooking-animation"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                    .frame(width: 200, height: 200)
                
                if showText{
                    VStack(spacing: 5) {
                        Text("Best Recipes")
                            .font(.poppinsSemibold(size: 40))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                        
                        Text("100k+ Premium Recipes")
                            .font(.poppinsRegular(size: 16))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showText = true
                }
            }
        }
    }
}
