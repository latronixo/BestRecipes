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
    @Namespace private var animation
    @State private var showContent: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Image(EnumConstructor.allCases[currentPage].backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .transition(.opacity.combined(with: .scale(scale: 1.05)))
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
                        .opacity(showContent ? 1.0 : 0.5)
                        .animation(.easeInOut(duration: 0.5), value: showContent)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Индикаторы страниц
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        if index == currentPage {
                            Capsule()
                                .fill(Color.green)
                                .frame(width: 40, height: 8)
                                .matchedGeometryEffect(id: "indicator", in: animation)
                        } else {
                            Capsule()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 40, height: 8)
                        }
                    }
                }
                .opacity(showContent ? 1.0 : 0.5)
                .animation(.easeInOut(duration: 0.5), value: showContent)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentPage)
                .padding(.bottom, currentPage == totalPages - 1 ? 110 : 130)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                withAnimation {
                    showContent = true
                }
            }
        }
    }
}
//
//#Preview{
//    MainOnboardingPage()
//}
