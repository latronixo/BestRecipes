//
//  CustomTabBar.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @State private var selectedTab: TabEnum
    
    init(initial: TabEnum = .home) {
        _selectedTab = State(initialValue: initial)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            selectedTab.screen
                .ignoresSafeArea()
                .frame(maxHeight: .infinity)
                .overlay(
                    VStack {
                        Spacer()
                    }
                )
            
            BottomTabBar(selectedTab: $selectedTab)

        }
    }
}

#Preview{
    CustomTabBar()
}
