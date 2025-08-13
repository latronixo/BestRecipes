//
//  SwiftDataServices.swift
//  BestRecipes
//
//  Created by Валентин on 11.08.2025.
//

import Foundation
import CoreData

// MARK: - RecipeCD Protocol
private protocol RecipeCD: NSManagedObject {
    var id: Int64 { get set }
    var dateAdded: Date? { get set }
    var image: String? { get set }
    var imageType: String? { get set }
    var title: String? { get set }
    var readyInMinutes: Int64 { get set }
    var servings: Int64 { get set }
    var sourceUrl: String? { get set }
    var vegetarian: Bool { get set }
    var vegan: Bool { get set }
    var glutenFree: Bool { get set }
    var dairyFree: Bool { get set }
    var veryHealthy: Bool { get set }
    var cheap: Bool { get set }
    var veryPopular: Bool { get set }
    var sustainable: Bool { get set }
    var lowFodmap: Bool { get set }
    var weightWatcherSmartPoints: Int64 { get set }
    var gaps: String? { get set }
    var preparationMinutes: Int64 { get set }
    var cookingMinutes: Int64 { get set }
    var aggregateLikes: Int64 { get set }
    var healthScore: Double { get set }
    var creditsText: String? { get set }
    var license: String? { get set }
    var sourceName: String? { get set }
    var pricePerServing: Double { get set }
    var spoonacularScore: Double { get set }
    var spoonacularSourceUrl: String? { get set }
    var summary: String? { get set }
    var instructions: String? { get set }
    var extendedIngredientsData: Data? { get set }
    var nutritionData: Data? { get set }
    var cuisinesData: Data? { get set }
    var dishTypesData: Data? { get set }
    var dietsData: Data? { get set }
    var occasionsData: Data? { get set }
    var analyzedInstructionsData: Data? { get set }
}

// MARK: - Protocol Conformance
extension RecentRecipeCD: RecipeCD {}
extension FavoriteRecipeCD: RecipeCD {}
extension MyRecipeCD: RecipeCD {}

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer
    private let maxRecentItems = 10
    
    private init() {
        container = NSPersistentContainer(name: "CoreDataModel")

        container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("не удалось загрузить хранилище CoreData: \(error), \(error.userInfo)")
            }
        }
        //в случае необходимости миграции новая версия объекта заменяет старую
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: Recent Recipes
    
    func addRecent(recipe: Recipe) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            container.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
                let fetchRequest: NSFetchRequest<RecentRecipeCD> = RecentRecipeCD.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", recipe.id)
                
                do {
                    if let existingRecipe = try self.context.fetch(fetchRequest).first {
                        existingRecipe.dateAdded = Date()
                    } else {
                        let newRecipe = RecentRecipeCD(context: self.context)
                        self.update(recipeCD: newRecipe, with: recipe)
                    }
                    
                    try self.cleanupRecentIfNeeded(context: context)
                    
                    if context.hasChanges {
                        try self.context.save()
                    }
                } catch {
                    print("Ошибка при добавлении или обновлении рецепта: \(error)")
                }
                continuation.resume()
            }
        }
    }
    
    func fetchRecentRecipes() async -> [Recipe] {
        return await withCheckedContinuation { continuation in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<RecentRecipeCD> = RecentRecipeCD.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                fetchRequest.fetchLimit = self.maxRecentItems
                
                do {
                    let coreDataRecipes = try context.fetch(fetchRequest)
                    let recipes = coreDataRecipes.compactMap { self.convert(from: $0) }
                    continuation.resume(returning: recipes)
                } catch {
                    print("Ошибка при извлечении рецептов: \(error)")
                }
                continuation.resume(returning: [])
            }
        }
    }
    
    //удаляет старые рецепты из таблицы RecentRecipesCD, если их количество превышает лимит
    private func cleanupRecentIfNeeded(context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<RecentRecipeCD> = RecentRecipeCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let allRecipes = try context.fetch(fetchRequest)
        
        if allRecipes.count > maxRecentItems {
            let recipesToDelete = allRecipes.prefix(allRecipes.count - maxRecentItems)
            for recipe in recipesToDelete {
                context.delete(recipe)
            }
        }
    }

    // MARK: Favorite Recipes
    
    func toggleFavorite(recipe: Recipe) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            container.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
                let fetchRequest: NSFetchRequest<FavoriteRecipeCD> = FavoriteRecipeCD.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(recipe.id))
                
                do {
                    if let existingRecipe = try self.context.fetch(fetchRequest).first {
                        self.context.delete(existingRecipe)
                    } else {
                        let newFavorite = FavoriteRecipeCD(context: context)
                        self.update(recipeCD: newFavorite, with: recipe)
                    }
                    
                    try self.context.save()
                } catch {
                    print("Ошибка при переключении статуса избранного: \(error)")
                    self.context.rollback()
                }
            }
        }
    }
    
    func isFavorite(id: Int) async -> Bool {
        return await withCheckedContinuation { continuation in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<FavoriteRecipeCD> = FavoriteRecipeCD.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(id))
                
                do {
                    let count = try context.count(for: fetchRequest)
                    continuation.resume(returning: count > 0)
                } catch {
                    print("Ошибка проверки нахождения в списке избранного: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    func fetchFavoriteRecipes() async -> [Recipe] {
        return await withCheckedContinuation { continuation in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<FavoriteRecipeCD> = FavoriteRecipeCD.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                do {
                    let coreDataRecipes = try context.fetch(fetchRequest)
                    let recipes = coreDataRecipes.compactMap { self.convert(from: $0) }
                    continuation.resume(returning: recipes)
                } catch {
                    print("Ошибка при извлечении избранных рецептов: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    // MARK: - Generic Converters
    
    private func update<T: RecipeCD>(recipeCD: T, with recipe: Recipe) {
        recipeCD.id = Int64(recipe.id)
        recipeCD.dateAdded = Date()
        recipeCD.image = recipe.image
        recipeCD.imageType = recipe.imageType
        recipeCD.title = recipe.title
        recipeCD.readyInMinutes = Int64(recipe.readyInMinutes)
        recipeCD.servings = Int64(recipe.servings)
        recipeCD.sourceUrl = recipe.sourceUrl
        recipeCD.vegetarian = recipe.vegetarian
        recipeCD.vegan = recipe.vegan
        recipeCD.glutenFree = recipe.glutenFree
        recipeCD.dairyFree = recipe.dairyFree
        recipeCD.veryHealthy = recipe.veryHealthy
        recipeCD.cheap = recipe.cheap
        recipeCD.veryPopular = recipe.veryPopular
        recipeCD.sustainable = recipe.sustainable
        recipeCD.lowFodmap = recipe.lowFodmap
        recipeCD.weightWatcherSmartPoints = Int64(recipe.weightWatcherSmartPoints ?? 0)
        recipeCD.gaps = recipe.gaps
        recipeCD.preparationMinutes = Int64(recipe.preparationMinutes ?? 0)
        recipeCD.cookingMinutes = Int64(recipe.cookingMinutes ?? 0)
        recipeCD.aggregateLikes = Int64(recipe.aggregateLikes)
        recipeCD.healthScore = recipe.healthScore
        recipeCD.creditsText = recipe.creditsText
        recipeCD.license = recipe.license
        recipeCD.sourceName = recipe.sourceName
        recipeCD.pricePerServing = recipe.pricePerServing ?? 0.0
        recipeCD.spoonacularScore = recipe.spoonacularScore
        recipeCD.spoonacularSourceUrl = recipe.spoonacularSourceUrl
        recipeCD.summary = recipe.summary
        recipeCD.instructions = recipe.instructions
        
        let encoder = JSONEncoder()
        
        recipeCD.extendedIngredientsData = try? encoder.encode(recipe.extendedIngredients)
        recipeCD.nutritionData = try? encoder.encode(recipe.nutrition)
        recipeCD.cuisinesData = try? encoder.encode(recipe.cuisines)
        recipeCD.dishTypesData = try? encoder.encode(recipe.dishTypes)
        recipeCD.dietsData = try? encoder.encode(recipe.diets)
        recipeCD.occasionsData = try? encoder.encode(recipe.occasions)
        recipeCD.analyzedInstructionsData = try? encoder.encode(recipe.analyzedInstructions)
    }
    
    private func convert<T: RecipeCD>(from recipeCD: T) -> Recipe? {
        let decoder = JSONDecoder()
        
        //поля-массивы не могут быть nil в сетевой модели (Recipe), поэтому даем им пустой массив по умолчанию
        let extendedIngredients = recipeCD.extendedIngredientsData.flatMap { try? decoder.decode([Ingredient].self, from: $0) } ?? []
        let cuisines = recipeCD.cuisinesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let dishTypes = recipeCD.dishTypesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let diets = recipeCD.dietsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let occasions = recipeCD.occasionsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let analyzedInstructions = recipeCD.analyzedInstructionsData.flatMap { try? decoder.decode([AnalyzedInstruction].self, from: $0) } ?? []
        
        let nutrition = recipeCD.nutritionData.flatMap { try? decoder.decode(Nutrition.self, from: $0) }

        return Recipe(
            id: Int(recipeCD.id),
            image: recipeCD.image,
            imageType: recipeCD.imageType ?? "",
            title: recipeCD.title ?? "",
            readyInMinutes: Int(recipeCD.readyInMinutes),
            servings: Int(recipeCD.servings),
            sourceUrl: recipeCD.sourceUrl,
            vegetarian: recipeCD.vegetarian,
            vegan: recipeCD.vegan,
            glutenFree: recipeCD.glutenFree,
            dairyFree: recipeCD.dairyFree,
            veryHealthy: recipeCD.veryHealthy,
            cheap: recipeCD.cheap,
            veryPopular: recipeCD.veryPopular,
            sustainable: recipeCD.sustainable,
            lowFodmap: recipeCD.lowFodmap,
            weightWatcherSmartPoints: Int(recipeCD.weightWatcherSmartPoints),
            gaps: recipeCD.gaps,
            preparationMinutes: Int(recipeCD.preparationMinutes),
            cookingMinutes: Int(recipeCD.cookingMinutes),
            aggregateLikes: Int(recipeCD.aggregateLikes),
            healthScore: recipeCD.healthScore,
            creditsText: recipeCD.creditsText,
            license: recipeCD.license,
            sourceName: recipeCD.sourceName,
            pricePerServing: Double(recipeCD.pricePerServing),
            extendedIngredients: extendedIngredients,
            nutrition: nutrition,
            summary: recipeCD.summary,
            cuisines: cuisines,
            dishTypes: dishTypes,
            diets: diets,
            occasions: occasions,
            instructions: recipeCD.instructions,
            analyzedInstructions: analyzedInstructions,
            spoonacularScore: recipeCD.spoonacularScore,
            spoonacularSourceUrl: recipeCD.spoonacularSourceUrl ?? ""
        )
    }
    
    // MARK: My Recipes
    
    func addMyRecipe(recipe: Recipe) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            container.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
                let fetchRequest: NSFetchRequest<MyRecipeCD> = MyRecipeCD.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", recipe.id)
                
                do {
                    if let existingRecipe = try context.fetch(fetchRequest).first {
                        self.update(recipeCD: existingRecipe, with: recipe)
                    } else  {
                        let newRecipe = MyRecipeCD(context: context)
                        self.update(recipeCD: newRecipe, with: recipe)
                    }
                    
                    if context.hasChanges {
                        try context.save()
                    }
                } catch {
                    print("Ошибка при добавлении или обновлении своего рецепта: \(error)")
                }
                continuation.resume()
            }
        }
    }
    
    func fetchMyRecipes() async -> [Recipe] {
        return await withCheckedContinuation { continuation in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<MyRecipeCD> = MyRecipeCD.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                do {
                    let coreDataRecipes = try context.fetch(fetchRequest)
                    let recipes = coreDataRecipes.compactMap { self.convert(from: $0) }
                    continuation.resume(returning: recipes)
                } catch {
                    print("Ошибка при извлечении своих рецептов: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    func deleteMyRecipe(id: Int) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            container.performBackgroundTask { container in
                let fetchRequest: NSFetchRequest<MyRecipeCD> = MyRecipeCD.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", id)
                
                do {
                    if let recipeToDelete = try self.context.fetch(fetchRequest).first {
                        self.context.delete(recipeToDelete)
                        try self.context.save()
                    }
                } catch {
                    print("Ошибка при удалении своего рецепта: \(error)")
                }
                continuation.resume()
            }
        }
    }
    
    private func updateMyRecipe(myRecipe: MyRecipeCD, with recipe: Recipe) {
            myRecipe.id = Int64(recipe.id)
            myRecipe.dateAdded = Date()
            myRecipe.image = recipe.image
            myRecipe.imageType = recipe.imageType
            myRecipe.title = recipe.title
            myRecipe.readyInMinutes = Int64(recipe.readyInMinutes)
            myRecipe.servings = Int64(recipe.servings)
            myRecipe.sourceUrl = recipe.sourceUrl
            myRecipe.vegetarian = recipe.vegetarian
            myRecipe.vegan = recipe.vegan
            myRecipe.glutenFree = recipe.glutenFree
            myRecipe.dairyFree = recipe.dairyFree
            myRecipe.veryHealthy = recipe.veryHealthy
            myRecipe.cheap = recipe.cheap
            myRecipe.veryPopular = recipe.veryPopular
            myRecipe.sustainable = recipe.sustainable
            myRecipe.lowFodmap = recipe.lowFodmap
            myRecipe.weightWatcherSmartPoints = Int64(recipe.weightWatcherSmartPoints ?? 0)
            myRecipe.gaps = recipe.gaps
            myRecipe.preparationMinutes = Int64(recipe.preparationMinutes ?? 0)
            myRecipe.cookingMinutes = Int64(recipe.cookingMinutes ?? 0)
            myRecipe.aggregateLikes = Int64(recipe.aggregateLikes)
            myRecipe.healthScore = recipe.healthScore
            myRecipe.creditsText = recipe.creditsText
            myRecipe.license = recipe.license
            myRecipe.sourceName = recipe.sourceName
            myRecipe.pricePerServing = recipe.pricePerServing ?? 0.0
            myRecipe.spoonacularScore = recipe.spoonacularScore
            myRecipe.spoonacularSourceUrl = recipe.spoonacularSourceUrl
            myRecipe.summary = recipe.summary
            myRecipe.instructions = recipe.instructions
            
            let encoder = JSONEncoder()
            
            myRecipe.extendedIngredientsData = try? encoder.encode(recipe.extendedIngredients)
            myRecipe.nutritionData = try? encoder.encode(recipe.nutrition)
            myRecipe.cuisinesData = try? encoder.encode(recipe.cuisines)
            myRecipe.dishTypesData = try? encoder.encode(recipe.dishTypes)
            myRecipe.dietsData = try? encoder.encode(recipe.diets)
            myRecipe.occasionsData = try? encoder.encode(recipe.occasions)
            myRecipe.analyzedInstructionsData = try? encoder.encode(recipe.analyzedInstructions)
        }
}
