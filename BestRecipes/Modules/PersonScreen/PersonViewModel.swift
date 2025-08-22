import Foundation
import SwiftUI

@MainActor
class PersonViewModel: ObservableObject {
    
    @Published var myRecipes: [Recipe] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    func fetchMyRecipes() async {
        myRecipes = await coreDataManager.fetchMyRecipes()
        print("Fetched \(myRecipes.count) recipes.")
    }
    
    func deleteRecipe(id: Int) async {
        await coreDataManager.deleteMyRecipe(id: id)
        await fetchMyRecipes() // Re-fetch to update the UI
    }
}
