//
//  MainOnboardingPage.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI

struct MainOnboardingPage: View {
    @State private var currentPage: Int = 0
    @State private var totalPages = 3
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Image(EnumConstructor.allCases[currentPage].backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        ContsructOnboardingView(
                            enumConstraction: EnumConstructor.allCases[index],
                            thirdScreen: index == totalPages - 1,
                            currentPage: $currentPage,
                            totalPages: $totalPages, shouldShowOnboarding: $shouldShowOnboarding
                        )
                        .tag(index)
                        .background(Color.clear)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Индикаторы страниц
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? Color.green : Color.gray.opacity(0.5))
                            .frame(width: 40, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, currentPage == totalPages - 1 ? 110 : 130)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
//
//#Preview{
//    MainOnboardingPage()
//}
