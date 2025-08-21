//
//  BestRecipesApp.swift
//  BestRecipes
//
//  Created by Валентин on 10.08.2025.
//

import SwiftUI

@main
struct BestRecipesApp: App {
    
    @State private var shouldOnboardingFinal = !OnboardingManager.onboardingFlag
    @State private var isActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                if isActive {
                    if shouldOnboardingFinal {
                        OnboardingView(shouldShowOnboarding: $shouldOnboardingFinal)
                            .transition(.opacity)
                    } else {
                        MainView()
                    }
                } else {
                    CookingLaunchScreen()
                }
            }
            .onAppear {
                // Через 2.5 секунды переключаем на следующий экран
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
