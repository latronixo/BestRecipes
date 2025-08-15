//
//  EnumConstructor.swift
//  BestRecipes
//
//  Created by Drolllted on 12.08.2025.
//

import Foundation

enum EnumConstructor: Int, CaseIterable {
    
    case first, second, third
    
    var backgroundImage: String {
        switch self {
            
        case .first:
            return "onboardingPage1"
        case .second:
            return "onboardingPage2"
        case .third:
            return "onboardingPage3"
        }
    }
}
