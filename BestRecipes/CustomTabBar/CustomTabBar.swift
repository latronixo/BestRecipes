//
//  CustomTabBar.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct TabItem {
    var name: String
}

struct CustomTabBar: View {
    
    @State private var selected: Int = 0
    
    let tabs = [
        TabItem(name: "home"),
        TabItem(name: "bookmark"),
        TabItem(name: "plus"),
        TabItem(name: "bell"),
        TabItem(name: "person"),
    ]
    
    var body: some View {
        TabView(selection: $selected) {
            //Сюда ваши экраны
            Color.gray.opacity(0.2)
                .tag(0)
            
            Color.gray.opacity(0.3)
                .tag(1)
            
            Color.gray.opacity(0.4)
                .tag(2)
            
            Color.gray.opacity(0.5)
                .tag(3)
            
            Color.gray.opacity(0.6)
                .tag(4)
        }
        .ignoresSafeArea()
        
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                if index == 2  {
                    
                } else {
                    
                }
            }
        }
    }
}

#Preview{
    CustomTabBar()
}
