//
//  SeeAllView.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import SwiftUI

struct SeeAllView: View {
    @StateObject private var viewModel = SeeAllViewModel()
    let category: SeeAllCategory
    
    var body: some View {
        ScrollView {
            Text("Отображение для категории: \(category.title)")
                .font(.title)
                .padding()
            
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView{
        SeeAllView(category: .trending)
    }
}
