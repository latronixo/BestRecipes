//
//  SwiftDataServices.swift
//  BestRecipes
//
//  Created by Валентин on 11.08.2025.
//

import Foundation
import CoreData

final class RecentRecipesManager {
    static let shared = RecentRecipesManager()
    
    private let container: NSPersistentContainer
    private let maxItems = 10
    
    private init() {
        container = NSPersistentContainer(name: "RecentRecipesModel")
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
    
    func add(recipe: Recipe) async {
        await context.perform { [weak self] in
            guard let self = self else { return }
            
            let fetchRequest: NSFetchRequest<RecentRecipeCD> = RecentRecipeCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", recipe.id)
            
            do {
                if let existingRecipe = try self.context.fetch(fetchRequest).first {
                    existingRecipe.dateAdded = Date()
                } else {
                    let newRecipe = RecentRecipeCD(context: self.context)
                    self.update(coreDataRecipe: newRecipe, with: recipe)
                }
                
                try self.cleanupIfNeeded()
                try self.context.save()
            } catch {
                print("Ошибка при добавлении или обновлении рецепта: \(error)")
                self.context.rollback()
            }
        }
    }
    
    func fetchRecipes() -> [Recipe] {
        let fetchRequest: NSFetchRequest<RecentRecipeCD> = RecentRecipeCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = maxItems
        
        do {
            let coreDataRecipes = try context.fetch(fetchRequest)
            return coreDataRecipes.compactMap { self.convertToRecipe(from: $0) }
        } catch {
            print("Ошибка при извлечении рецептов: \(error)")
            return []
        }
    }
    
    //удаляет старые рецепты из таблицы RecentRecipesCD, если их количество превышает лимит
    private func cleanupIfNeeded() throws {
        let fetchRequest: NSFetchRequest<RecentRecipeCD> = RecentRecipeCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let allRecipes = try context.fetch(fetchRequest)
        
        if allRecipes.count > maxItems {
            let recipesToDelete = allRecipes.prefix(allRecipes.count - maxItems)
            for recipe in recipesToDelete {
                context.delete(recipe)
            }
        }
    }

    //заполняет таблицу CoreData данными из сетевой модели
    private func update(coreDataRecipe: RecentRecipeCD, with recipe: Recipe) {
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
    private func convertToRecipe(from cdRecipe: RecentRecipeCD) -> Recipe? {
        let decoder = JSONDecoder()
        
        //поля-массивы не могут быть nil в сетевой модели (Recipe), поэтому даем им пустой массив по умолчанию
        let extendedIngredients = cdRecipe.extendedIngredientsData.flatMap { try? decoder.decode([Ingredient].self, from: $0) } ?? []
        let cuisines = cdRecipe.cuisinesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let dishTypes = cdRecipe.dishTypesData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let diets = cdRecipe.dietsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let occasions = cdRecipe.occasionsData.flatMap { try? decoder.decode([String].self, from: $0) } ?? []
        let analyzedInstructions = cdRecipe.analyzedInstructionsData.flatMap { try? decoder.decode([AnalyzedInstruction].self, from: $0) } ?? []
        
        let nutrition = cdRecipe.nutritionData.flatMap { try? decoder.decode(Nutrition.self, from: $0) }

        return Recipe(
            id: Int(cdRecipe.id),
            image: cdRecipe.image,
            imageType: cdRecipe.imageType ?? "",
            title: cdRecipe.title ?? "",
            readyInMinutes: Int(cdRecipe.readyInMinutes),
            servings: Int(cdRecipe.servings),
            sourceUrl: cdRecipe.sourceUrl,
            vegetarian: cdRecipe.vegetarian,
            vegan: cdRecipe.vegan,
            glutenFree: cdRecipe.glutenFree,
            dairyFree: cdRecipe.dairyFree,
            veryHealthy: cdRecipe.veryHealthy,
            cheap: cdRecipe.cheap,
            veryPopular: cdRecipe.veryPopular,
            sustainable: cdRecipe.sustainable,
            lowFodmap: cdRecipe.lowFodmap,
            weightWatcherSmartPoints: Int(cdRecipe.weightWatcherSmartPoints),
            gaps: cdRecipe.gaps,
            preparationMinutes: Int(cdRecipe.preparationMinutes),
            cookingMinutes: Int(cdRecipe.cookingMinutes),
            aggregateLikes: Int(cdRecipe.aggregateLikes),
            healthScore: cdRecipe.healthScore,
            creditsText: cdRecipe.creditsText,
            license: cdRecipe.license,
            sourceName: cdRecipe.sourceName,
            pricePerServing: Double(cdRecipe.pricePerServing),
            extendedIngredients: extendedIngredients,
            nutrition: nutrition,
            summary: cdRecipe.summary,
            cuisines: cuisines,
            dishTypes: dishTypes,
            diets: diets,
            occasions: occasions,
            instructions: cdRecipe.instructions,
            analyzedInstructions: analyzedInstructions,
            spoonacularScore: cdRecipe.spoonacularScore,
            spoonacularSourceUrl: cdRecipe.spoonacularSourceUrl ?? ""
        )
    }
}
