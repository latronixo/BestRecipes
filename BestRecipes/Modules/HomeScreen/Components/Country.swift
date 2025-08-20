//
//  Country.swift
//  BestRecipes
//
//  Created by Dmitry Volkov on 15/08/2025.
//

import SwiftUI

struct Country: View {
    let country: CuisineType
    
    var body: some View {
        VStack {
            Image(country.rawValue.capitalized)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
            Text(country.rawValue.capitalized)
                .font(.poppinsSemibold(size: 16))
                .padding(.top)
        }
        .padding(.trailing, 10)
    }
}

