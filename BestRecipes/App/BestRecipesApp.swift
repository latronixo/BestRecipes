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
    
    var body: some Scene {
        WindowGroup {
            if shouldOnboardingFinal {
                OnboardingView(shouldShowOnboarding: $shouldOnboardingFinal)
                    .transition(.opacity)
            } else {
                MainView()
                    .transition(.opacity)
            }
        }
    }
}
