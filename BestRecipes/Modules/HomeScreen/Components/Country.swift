//
//  Country.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 15/08/2025.
//

import SwiftUI

struct Country: View {
    let country: String
    
    var body: some View {
        VStack {
            Image(country)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .clipShape(Circle())
            Text(country)
                .font(.poppinsSemibold(size: 16))
        }
        .padding(.trailing, 10)
    }
}

