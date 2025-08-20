//
//  CustomTabBar.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabEnum
    
    var body: some View {
        BottomTabBar(selectedTab: $selectedTab)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTab: TabEnum = .home
        var body: some View {
            ZStack(alignment: .bottom) {
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
    return PreviewWrapper()
}
