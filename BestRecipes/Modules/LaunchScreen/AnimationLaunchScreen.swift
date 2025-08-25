//
//  AnimationLaunchScreen.swift
//  BestRecipes
//
//  Created by Drolllted on 25.08.2025.
//

import SwiftUI
import Lottie

struct AnimationLaunchScreen: View {
    
    @State private var showText: Bool = false
    
    var body: some View {
        ZStack {
            Image("backOnboardingImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            LinearGradient(colors: [.clear, Color.black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center, spacing: 30) {
                LottieView(animation: .named("cooking-animation"))
                    //.playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                    .frame(width: 200, height: 200)
                
                if showText {
                    VStack(spacing: 5){
                        Text("Best Recipes")
                            .font(.poppinsSemibold(size: 40))
                            .foregroundStyle(.white)
                            .transition(.scale.combined(with: .opacity))
                        
                        Text("100k+ Premium Recipes")
                            .font(.poppinsRegular(size: 16))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .transition(.scale.combined(with: .opacity))
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

#Preview{
    AnimationLaunchScreen()
}
