//
//  SeeAllView.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import SwiftUI

struct SeeAllView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = SeeAllViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var recipes: [Recipe] = []
    let category: SeeAllCategory
    private let tabBarHeight: CGFloat = 60
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(viewModel.trendingRecipes) { recipe in
                    Button {
                        router.goTo(to: .detailScreen(recipe: recipe))
                    } label: {
                        RecipeCardView()
                            .environmentObject(
                                RecipeCardViewModel(
                                    recipe: recipe,
                                    isBookmarked: false
                                )
                            )
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.bottom, tabBarHeight)
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundStyle(.text)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchTrendingRecipes()
            }
        }
    }
}

#Preview {
    NavigationView{
        SeeAllView(category: .trending)
    }
}
