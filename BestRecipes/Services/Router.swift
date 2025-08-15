//
//  Router.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import Foundation
import SwiftUI


class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func goTo(to route: Routes) {
        path.append(route)
    }
    
    func goBack() {
    
        if path.isEmpty { return }
        path.removeLast()
        
    }
    
    func goToRoot() {
        path.removeLast(path.count)
    }
    
    func popToView(count: Int) {
        path.removeLast(count)
    }
    
    
    
}
