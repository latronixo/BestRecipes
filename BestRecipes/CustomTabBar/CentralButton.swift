//
//  CentralButton.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct CentralButton: View {
    
    //var action: () -> Void
    
    var body: some View {
        Button {
         //   action()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 44, height: 44)
                    .shadow(color: Color.red.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image("plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                
            }
        }

    }
}

#Preview {
    CentralButton()
}
