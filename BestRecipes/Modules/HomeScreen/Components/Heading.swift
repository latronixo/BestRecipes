//
//  Heading.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct Heading: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
                .font(.title2)
            Spacer()
            Button {
                
            } label: {
                HStack {
                    Text("See all")
                        .foregroundStyle(.red)
                    Image("Arrow-Right")
                }
            }
        }
        .padding(.trailing)
        .padding(.vertical)
    }
}

#Preview {
    Heading(title: "Trending now 🔥")
}
