//
//  CustomTabBar.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @State private var selectedTab: TabEnum = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Основной контент
            selectedTab.screen
                .ignoresSafeArea()
                .frame(maxHeight: .infinity)
                .overlay(
                    VStack {
                        Spacer()
                    }
                ) // Добавляем отступ снизу для TabBar
            
            // Кастомный TabBar
            HStack(spacing: 0) {
                ForEach(TabEnum.allCases, id: \.self) { tab in
                    if tab == .add {
                        CentralButton(selected: $selectedTab, index: tab)
                            .offset(y: -20)
                    } else {
                        TabButton(tab: tab, isSelected: selectedTab == tab) {
                            selectedTab = tab
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 60)
            .background(
                Color.white
                    .clipShape(RectangleTopShape())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -3)
                    .mask(
                        Rectangle()
                            .padding(.top, -20)
                    )
            )
        }
    }
}

#Preview{
    CustomTabBar()
}
