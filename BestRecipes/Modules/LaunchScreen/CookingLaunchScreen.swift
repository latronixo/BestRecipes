//
//  CookingLaunchScreen.swift
//  BestRecipes
//
//  Created by Drolllted on 21.08.2025.
//

import SwiftUI
import Lottie

struct CookingLaunchScreen: View {
    @State private var animationStage: Int = 0
    
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
                if animationStage >= 0 {
                    LottieView(animation: .named("cooking-animation"))
                        .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                        .animationDidFinish { _ in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                animationStage = 1
                            }
                        }
                        .frame(width: 200, height: 200)
                        .transition(.opacity)
                }
                
                // Текст после завершения анимации
                if animationStage >= 1 {
                    VStack(spacing: 5) {
                        Text("Best Recipes")
                            .font(.poppinsSemibold(size: 40))
                            .foregroundColor(.white)
                        
                        Text("100k+ Premium Recipes")
                            .font(.poppinsRegular(size: 16))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            // Начинаем с stage 0 (Lottie анимация)
            animationStage = 0
        }
    }
}
