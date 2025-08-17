//
//  PersonView.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI

struct PersonView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack{
                    Image("avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    Spacer()
                }
                .padding()
                
                
                
                Spacer()
            }
            .toolbar {
                    Text("My Profile")
                        .font(.poppinsSemibold(size: 24))
                        .foregroundStyle(.black)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PersonView()
}
