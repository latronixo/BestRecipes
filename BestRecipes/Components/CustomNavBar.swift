//
//  CustomNavBar.swift
//  BestRecipes
//
//  Created by Валентин on 22.08.2025.
//

import SwiftUI

struct CustomNavBar: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.poppinsSemibold(size: 24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .padding(.top, 10)
            
            Spacer()
        }
        .frame(height: 50)
        .background(Color(.systemBackground))
    }
}

#Preview {
    CustomNavBar(title: "Get amazing recipes for cooking")
}
