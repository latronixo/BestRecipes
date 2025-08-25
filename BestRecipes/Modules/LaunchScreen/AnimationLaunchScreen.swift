//
//  AnimationLaunchScreen.swift
//  BestRecipes
//
//  Created by Drolllted on 25.08.2025.
//

import SwiftUI

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
                
            }
        }
    }
}

#Preview{
    AnimationLaunchScreen()
}
