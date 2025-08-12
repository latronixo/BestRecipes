//
//  BottomTabBar.swift
//  BestRecipes
//
//  Created by Nadia on 12/08/2025.
//

import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: TabEnum

    var body: some View {
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
                .mask(Rectangle().padding(.top, -20))
        )
    }
}

// MARK: - Preview
#Preview {
    struct BottomTabBarPreview: View {
        @State private var tab: TabEnum = .home
        var body: some View {
            BottomTabBar(selectedTab: $tab)
                .previewLayout(.sizeThatFits)
        }
    }
    return BottomTabBarPreview()
}

