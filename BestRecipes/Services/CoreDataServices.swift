//
//  SwiftDataServices.swift
//  BestRecipes
//
//  Created by Валентин on 11.08.2025.
//

import Foundation
import CoreData

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
                        self.updateRecent(coreDataRecipe: newRecipe, with: recipe)
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
                    let recipes = coreDataRecipes.compactMap { self.convertToRecentRecipe(from: $0) }
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

    //заполняет таблицу CoreData данными из сетевой модели
    private func updateRecent(coreDataRecipe: RecentRecipeCD, with recipe: Recipe) {
        coreDataRecipe.id = Int64(recipe.id)
        coreDataRecipe.dateAdded = Date()
        coreDataRecipe.image = recipe.image
        coreDataRecipe.imageType = recipe.imageType
        coreDataRecipe.title = recipe.title
        coreDataRecipe.readyInMinutes = Int64(recipe.readyInMinutes)
        coreDataRecipe.servings = Int64(recipe.servings)
        coreDataRecipe.sourceUrl = recipe.sourceUrl
        coreDataRecipe.vegetarian = recipe.vegetarian
        coreDataRecipe.vegan = recipe.vegan
        coreDataRecipe.glutenFree = recipe.glutenFree
        coreDataRecipe.dairyFree = recipe.dairyFree
        coreDataRecipe.veryHealthy = recipe.veryHealthy
        coreDataRecipe.cheap = recipe.cheap
        coreDataRecipe.veryPopular = recipe.veryPopular
        coreDataRecipe.sustainable = recipe.sustainable
        coreDataRecipe.lowFodmap = recipe.lowFodmap
        coreDataRecipe.weightWatcherSmartPoints = recipe.weightWatcherSmartPoints.map { NSNumber(value: $0) } as! Int64
        coreDataRecipe.gaps = recipe.gaps
        coreDataRecipe.preparationMinutes = recipe.preparationMinutes.map { NSNumber(value: $0) } as! Int64
        coreDataRecipe.cookingMinutes = recipe.cookingMinutes.map { NSNumber(value: $0) } as! Int64
        coreDataRecipe.aggregateLikes = Int64(recipe.aggregateLikes)
        coreDataRecipe.healthScore = recipe.healthScore
        coreDataRecipe.creditsText = recipe.creditsText
        coreDataRecipe.license = recipe.license
        coreDataRecipe.sourceName = recipe.sourceName
        coreDataRecipe.pricePerServing = Double(recipe.pricePerServing.map { NSNumber(value: $0) } as! Double)
        coreDataRecipe.spoonacularScore = recipe.spoonacularScore
        coreDataRecipe.spoonacularSourceUrl = recipe.spoonacularSourceUrl
        coreDataRecipe.summary = recipe.summary
        coreDataRecipe.instructions = recipe.instructions
        
        let encoder = JSONEncoder()
        coreDataRecipe.extendedIngredientsData = try? encoder.encode(recipe.extendedIngredients)
        coreDataRecipe.nutritionData = try? encoder.encode(recipe.nutrition)
        coreDataRecipe.cuisinesData = try? encoder.encode(recipe.cuisines)
        coreDataRecipe.dishTypesData = try? encoder.encode(recipe.dishTypes)
        coreDataRecipe.dietsData = try? encoder.encode(recipe.diets)
        coreDataRecipe.occasionsData = try? encoder.encode(recipe.occasions)
        coreDataRecipe.analyzedInstructionsData = try? encoder.encode(recipe.analyzedInstructions)
    }
    
    //конвертирует объект (запись) CoreData обратно в сетевую модель Recipe
    private func convertToRecentRecipe(from cdRecent: RecentRecipeCD) -> Recipe? {
        let decoder = JSONDecoder()
        
        //поля-массивы не могут быть nil в сетевой модели (Recipe), поэтому даем им пустой массив по умолчанию
        let extendedIngredients = cdRecent.extendedIngredientsData.flatMap { try? decoder.decode([Ingredient].self, from: $0) } ?? []
        let cuisines = cdRecent.cuisinesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let dishTypes = cdRecent.dishTypesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let diets = cdRecent.dietsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let occasions = cdRecent.occasionsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let analyzedInstructions = cdRecent.analyzedInstructionsData.flatMap { try? decoder.decode([AnalyzedInstruction].self, from: $0) } ?? []
        
        let nutrition = cdRecent.nutritionData.flatMap { try? decoder.decode(Nutrition.self, from: $0) }

        return Recipe(
            id: Int(cdRecent.id),
            image: cdRecent.image,
            imageType: cdRecent.imageType ?? "",
            title: cdRecent.title ?? "",
            readyInMinutes: Int(cdRecent.readyInMinutes),
            servings: Int(cdRecent.servings),
            sourceUrl: cdRecent.sourceUrl,
            vegetarian: cdRecent.vegetarian,
            vegan: cdRecent.vegan,
            glutenFree: cdRecent.glutenFree,
            dairyFree: cdRecent.dairyFree,
            veryHealthy: cdRecent.veryHealthy,
            cheap: cdRecent.cheap,
            veryPopular: cdRecent.veryPopular,
            sustainable: cdRecent.sustainable,
            lowFodmap: cdRecent.lowFodmap,
            weightWatcherSmartPoints: Int(cdRecent.weightWatcherSmartPoints),
            gaps: cdRecent.gaps,
            preparationMinutes: Int(cdRecent.preparationMinutes),
            cookingMinutes: Int(cdRecent.cookingMinutes),
            aggregateLikes: Int(cdRecent.aggregateLikes),
            healthScore: cdRecent.healthScore,
            creditsText: cdRecent.creditsText,
            license: cdRecent.license,
            sourceName: cdRecent.sourceName,
            pricePerServing: Double(cdRecent.pricePerServing),
            extendedIngredients: extendedIngredients,
            nutrition: nutrition,
            summary: cdRecent.summary,
            cuisines: cuisines,
            dishTypes: dishTypes,
            diets: diets,
            occasions: occasions,
            instructions: cdRecent.instructions,
            analyzedInstructions: analyzedInstructions,
            spoonacularScore: cdRecent.spoonacularScore,
            spoonacularSourceUrl: cdRecent.spoonacularSourceUrl ?? ""
        )
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
                        self.updateFavorite(favoriteRecipe: newFavorite, with: recipe)
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
                    let recipes =  coreDataRecipes.compactMap { self.convertToFavoriteRecipe(from: $0) }
                    continuation.resume(returning: recipes)
                } catch {
                    print("Ошибка при извлечении избранных рецептов: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    private func updateFavorite(favoriteRecipe: FavoriteRecipeCD, with recipe: Recipe) {
        favoriteRecipe.id = Int64(recipe.id)
        favoriteRecipe.dateAdded = Date()
        favoriteRecipe.image = recipe.image
        favoriteRecipe.imageType = recipe.imageType
        favoriteRecipe.title = recipe.title
        favoriteRecipe.readyInMinutes = Int64(recipe.readyInMinutes)
        favoriteRecipe.servings = Int64(recipe.servings)
        favoriteRecipe.sourceUrl = recipe.sourceUrl
        favoriteRecipe.vegetarian = recipe.vegetarian
        favoriteRecipe.vegan = recipe.vegan
        favoriteRecipe.glutenFree = recipe.glutenFree
        favoriteRecipe.dairyFree = recipe.dairyFree
        favoriteRecipe.veryHealthy = recipe.veryHealthy
        favoriteRecipe.cheap = recipe.cheap
        favoriteRecipe.veryPopular = recipe.veryPopular
        favoriteRecipe.sustainable = recipe.sustainable
        favoriteRecipe.lowFodmap = recipe.lowFodmap
        favoriteRecipe.weightWatcherSmartPoints = recipe.weightWatcherSmartPoints.map { NSNumber(value: $0) } as! Int64
        favoriteRecipe.gaps = recipe.gaps
        favoriteRecipe.preparationMinutes = recipe.preparationMinutes.map { NSNumber(value: $0) } as! Int64
        favoriteRecipe.cookingMinutes = recipe.cookingMinutes.map { NSNumber(value: $0) } as! Int64
        favoriteRecipe.aggregateLikes = Int64(recipe.aggregateLikes)
        favoriteRecipe.healthScore = recipe.healthScore
        favoriteRecipe.creditsText = recipe.creditsText
        favoriteRecipe.license = recipe.license
        favoriteRecipe.sourceName = recipe.sourceName
        favoriteRecipe.pricePerServing = Double(recipe.pricePerServing.map { NSNumber(value: $0) } as! Double)
        favoriteRecipe.spoonacularScore = recipe.spoonacularScore
        favoriteRecipe.spoonacularSourceUrl = recipe.spoonacularSourceUrl
        favoriteRecipe.summary = recipe.summary
        favoriteRecipe.instructions = recipe.instructions
        
        let encoder = JSONEncoder()
        
        favoriteRecipe.extendedIngredientsData = try? encoder.encode(recipe.extendedIngredients)
        favoriteRecipe.nutritionData = try? encoder.encode(recipe.nutrition)
        favoriteRecipe.cuisinesData = try? encoder.encode(recipe.cuisines)
        favoriteRecipe.dishTypesData = try? encoder.encode(recipe.dishTypes)
        favoriteRecipe.dietsData = try? encoder.encode(recipe.diets)
        favoriteRecipe.occasionsData = try? encoder.encode(recipe.occasions)
        favoriteRecipe.analyzedInstructionsData = try? encoder.encode(recipe.analyzedInstructions)
    }
    
    private func convertToFavoriteRecipe(from cdFavorite: FavoriteRecipeCD) -> Recipe? {
        let decoder = JSONDecoder()
        
        //поля-массивы не могут быть nil в сетевой модели (Recipe), поэтому даем им пустой массив по умолчанию
        let extendedIngredients = cdFavorite.extendedIngredientsData.flatMap { try? decoder.decode([Ingredient].self, from: $0) } ?? []
        let cuisines = cdFavorite.cuisinesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let dishTypes = cdFavorite.dishTypesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let diets = cdFavorite.dietsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let occasions = cdFavorite.occasionsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let analyzedInstructions = cdFavorite.analyzedInstructionsData.flatMap { try? decoder.decode([AnalyzedInstruction].self, from: $0) } ?? []
        
        let nutrition = cdFavorite.nutritionData.flatMap { try? decoder.decode(Nutrition.self, from: $0) }

        return Recipe(
            id: Int(cdFavorite.id),
            image: cdFavorite.image,
            imageType: cdFavorite.imageType ?? "",
            title: cdFavorite.title ?? "",
            readyInMinutes: Int(cdFavorite.readyInMinutes),
            servings: Int(cdFavorite.servings),
            sourceUrl: cdFavorite.sourceUrl,
            vegetarian: cdFavorite.vegetarian,
            vegan: cdFavorite.vegan,
            glutenFree: cdFavorite.glutenFree,
            dairyFree: cdFavorite.dairyFree,
            veryHealthy: cdFavorite.veryHealthy,
            cheap: cdFavorite.cheap,
            veryPopular: cdFavorite.veryPopular,
            sustainable: cdFavorite.sustainable,
            lowFodmap: cdFavorite.lowFodmap,
            weightWatcherSmartPoints: Int(cdFavorite.weightWatcherSmartPoints),
            gaps: cdFavorite.gaps,
            preparationMinutes: Int(cdFavorite.preparationMinutes),
            cookingMinutes: Int(cdFavorite.cookingMinutes),
            aggregateLikes: Int(cdFavorite.aggregateLikes),
            healthScore: cdFavorite.healthScore,
            creditsText: cdFavorite.creditsText,
            license: cdFavorite.license,
            sourceName: cdFavorite.sourceName,
            pricePerServing: Double(cdFavorite.pricePerServing),
            extendedIngredients: extendedIngredients,
            nutrition: nutrition,
            summary: cdFavorite.summary,
            cuisines: cuisines,
            dishTypes: dishTypes,
            diets: diets,
            occasions: occasions,
            instructions: cdFavorite.instructions,
            analyzedInstructions: analyzedInstructions,
            spoonacularScore: cdFavorite.spoonacularScore,
            spoonacularSourceUrl: cdFavorite.spoonacularSourceUrl ?? ""
        )
    }
}
