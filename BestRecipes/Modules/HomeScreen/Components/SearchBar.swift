//
//  SearchBar.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 11/08/2025.
//

import SwiftUI

struct SearchBar: View {
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            Text("How to")
                .font(.footnote)
                .fontWeight(.semibold)
            Spacer()
            Button {} label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
            }

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(.systemGray3))
        }
        .padding(.trailing)
    }
}
