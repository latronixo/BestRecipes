//
//  CentralButton.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct CentralButton: View {
    @Binding var selected: Int
    var index: Int
    
    var body: some View {
        Button {
        selected = index
        } label: {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 44, height: 44)
                  //  .shadow(color: Color.red.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image("plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                
            }
        }

    }
}
