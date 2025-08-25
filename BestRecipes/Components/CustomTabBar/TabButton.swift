//
//  TabButton.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct TabButton: View {
        
    let tab: TabEnum
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(tab.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .background {
                    if isSelected {
                        Color.red.opacity(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 22, height: 22)
                    }
                }
        }
    }
}

