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
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $currentPage){
                ContsructOnboardingView(enumConstraction: .first, thirdScreen: false, currentPage: $currentPage, totalPages: $totalPages)
                    .tag(0)
                ContsructOnboardingView(enumConstraction: .second, thirdScreen: false, currentPage: $currentPage, totalPages: $totalPages)
                    .tag(1)
                ContsructOnboardingView(enumConstraction: .third, thirdScreen: true, currentPage: $currentPage, totalPages: $totalPages)
                    .tag(2)
            }
            .ignoresSafeArea(.all)
            .tabViewStyle(.page(indexDisplayMode: .never))
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Capsule()
                        .fill(index == currentPage ? Color.green : Color.gray.opacity(0.5))
                        .frame(width: 40, height: 8)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            .padding(.bottom, currentPage == totalPages - 1 ? 100 : 120)
        }
    }
}

#Preview{
    MainOnboardingPage()
}
