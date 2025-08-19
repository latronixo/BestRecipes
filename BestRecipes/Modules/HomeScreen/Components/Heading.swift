//
//  Heading.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct Heading: View {
    var title: String
    var action: () -> Void = {}
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
                .font(.poppinsSemibold(size: 20))
            Spacer()
            Button {
                action()
            } label: {
                HStack {
                    Text("See all")
                        .font(.poppinsSemibold(size: 14))
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
