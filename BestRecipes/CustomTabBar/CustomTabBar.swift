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
        ZStack(alignment: .bottom) {
            TabView(selection: $selected) {
                //Сюда ваши экраны
                
                //HomeView
                Color.white
                    .tag(0)
                
                //BookmarkView
                Color.gray.opacity(0.3)
                    .tag(1)
                
                //AddView
                Color.gray.opacity(0.4)
                    .tag(2)
                
                //BellView(Заглушка)
                Color.gray.opacity(0.5)
                    .tag(3)
                
                //PersonView
                Color.gray.opacity(0.6)
                    .tag(4)
            }
            .ignoresSafeArea()
            .background(.clear)
            
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    if index == 2  {
                        CentralButton(selected: $selected, index: index)
                            .offset(y: -25)
                    } else {
                        TabButton(name: tabs[index], isSelected: selected == index) {
                            selected = index
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
        }
            .frame(height: 60)
            .background(content: {
                Color.white
                    .clipShape(RectangleTopShape())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -3)
                    .mask(
                        Rectangle()
                            .padding(.top, -20)
                    )
            })
        }
    }
}

#Preview{
    CustomTabBar()
}
