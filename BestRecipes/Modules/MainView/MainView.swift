//
//  MainView.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import SwiftUI



struct MainView: View {
    
    @StateObject private var router = Router()
    @State private var selectedTab: TabEnum = .home
    
    var body: some View {
        
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomeScreenView()
                        .tag(TabEnum.home)
                    
                    DiscoverView()
                        .tag(TabEnum.bookmarks)
                    
                    AddRecipeView()
                        .tag(TabEnum.add)
                    
                    BellView()
                        .tag(TabEnum.notifications)
                    
                    PersonView()
                        .tag(TabEnum.profile)
                }
                .padding(.top, selectedTab.title.isEmpty ? 0 : 50)
                
                if !selectedTab.title.isEmpty {
                    VStack {
                        CustomNavBar(title: selectedTab.title)
                        Spacer()
                    }
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
            .navigationDestination(for: Routes.self) { route in
                switch route {
                case .homeScreen:
                    HomeScreenView()
                case .detailScreen(let recipe):
                    DetailView(detailVM: DetailViewModel(recipe: recipe, router: router))
                case .seeAllScreen(let category):
                    SeeAllView(category: category)
                case .searchScreen:
                    SearchScreenView()
                case .createScreen:
                    AddRecipeView()
                case .profileScreen:
                    PersonView()
                }
                
            }
            
        }
        .tint(.black)
        
        .environmentObject(router)
    }
}

#Preview {
    MainView()
}
