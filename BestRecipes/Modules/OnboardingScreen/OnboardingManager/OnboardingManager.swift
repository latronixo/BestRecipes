//
//  OnboardingManager.swift
//  BestRecipes
//
//  Created by Drolllted on 13.08.2025.
//

import Foundation

final class OnboardingManager {
    private static var onboardingKey: String = "OnboardingKey"
    
    static var onboardingFlag: Bool {
        get {
            UserDefaults.standard.bool(forKey: onboardingKey)
        } set {
            UserDefaults.standard.set(newValue, forKey: onboardingKey)
        }
    }
    
    static func completeOnboarding() {
        onboardingFlag = true
    }
    
    //MARK: - For Tests
    
    static func resetOnboarding() {
        onboardingFlag = false
    }
}
