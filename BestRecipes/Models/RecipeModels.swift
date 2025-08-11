//
//  RecipeModels.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import Foundation

// MARK: - Recipe Model
struct Recipe: Codable, Identifiable {
    // MARK: - Основная информация
    let id: Int                                    // Уникальный ID рецепта
    let image: String?                             // URL изображения рецепта
    let imageType: String?                         // Тип изображения (jpg, png и т.д.)
    let title: String                              // Название рецепта
    let readyInMinutes: Int                        // Общее время приготовления (мин)
    let servings: Int                              // Количество порций
    let sourceUrl: String?                         // Ссылка на оригинальный рецепт
    
    // MARK: - Особенности диеты
    let vegetarian: Bool                           // Вегетарианский рецепт
    let vegan: Bool                                // Веганский рецепт
    let glutenFree: Bool                           // Без глютена
    let dairyFree: Bool                            // Без молочных продуктов
    let veryHealthy: Bool                          // Очень полезный
    let cheap: Bool                                // Дешевый в приготовлении
    let veryPopular: Bool                          // Очень популярный
    let sustainable: Bool                          // Экологически устойчивый
    let lowFodmap: Bool                            // Подходит для диеты FODMAP
    
    // MARK: - Дополнительная информация
    let weightWatcherSmartPoints: Int?             // Баллы Weight Watchers
    let gaps: String?                              // Соответствие диете GAPS
    let preparationMinutes: Int?                   // Время подготовки (мин)
    let cookingMinutes: Int?                       // Время готовки (мин)
    let aggregateLikes: Int                        // Количество лайков
    let healthScore: Double                        // Оценка полезности (0-100)
    let creditsText: String?                       // Информация об авторах
    let license: String?                           // Лицензия на рецепт
    let sourceName: String?                        // Название источника
    let pricePerServing: Double?                   // Цена за порцию (USD)
    
    // MARK: - Состав и инструкции
    let extendedIngredients: [Ingredient]          // Список ингредиентов
    let nutrition: Nutrition?                      // Информация о питательности
    let summary: String?                           // Краткое описание рецепта
    let cuisines: [String]                         // Типы кухни (итальянская, китайская)
    let dishTypes: [String]                        // Типы блюд (закуска, основное)
    let diets: [String]                            // Подходящие диеты
    let occasions: [String]                        // Подходящие случаи (завтрак, ужин)
    let instructions: String?                      // Инструкции приготовления (текст)
    let analyzedInstructions: [AnalyzedInstruction] // Структурированные инструкции
    
    // MARK: - Оценки Spoonacular
    let spoonacularScore: Double                   // Внутренняя оценка качества
    let spoonacularSourceUrl: String               // URL в системе Spoonacular
}

// MARK: - Ingredient Model
struct Ingredient: Codable, Identifiable {
    // MARK: - Основная информация
    let id: Int                     // Уникальный ID ингредиента
    let aisle: String?              // Отдел в магазине (молочный, мясной)
    let image: String?              // Название изображения ингредиента
    let consistency: String?        // Консистенция (жидкая, твердая)
    let name: String                // Название ингредиента
    let nameClean: String?          // Очищенное название без брендов
    let original: String            // Оригинальная строка из рецепта
    let originalName: String        // Оригинальное название
    
    // MARK: - Количество и единицы
    let amount: Double              // Количество
    let unit: String                // Единица измерения (стакан, ложка)
    let meta: [String]              // Дополнительная информация (нарезанный, свежий)
    let measures: Measures          // Единицы измерения (US/метрические)
}

// MARK: - Measures Model
struct Measures: Codable {
    let us: MeasureUnit         // Американские единицы измерения
    let metric: MeasureUnit     // Метрические единицы измерения
}

// MARK: - MeasureUnit Model
struct MeasureUnit: Codable {
    let amount: Double          // Количество в данной системе мер
    let unitShort: String       // Краткое название единицы (г, мл)
    let unitLong: String        // Полное название единицы (граммы, миллилитры)
}

// MARK: - Nutrition Model
struct Nutrition: Codable {
    let nutrients: [Nutrient]               // Список питательных веществ
    let caloricBreakdown: CaloricBreakdown? // Распределение калорий по БЖУ
    let weightPerServing: WeightPerServing? // Вес одной порции
}

// MARK: - Nutrient Model
struct Nutrient: Codable, Identifiable {
    let name: String                        // Название нутриента (Calories, Protein)
    let amount: Double                      // Количество
    let unit: String                        // Единица измерения (g, mg, kcal)
    let percentOfDailyNeeds: Double?        // Процент от дневной нормы
    
    var id: String { name }
}

// MARK: - CaloricBreakdown Model
struct CaloricBreakdown: Codable {
    let percentProtein: Double              // Процент калорий из белков
    let percentFat: Double                  // Процент калорий из жиров
    let percentCarbs: Double                // Процент калорий из углеводов
}

// MARK: - WeightPerServing Model
struct WeightPerServing: Codable {
    let amount: Double                      // Количество
    let unit: String                        // Единица измерения веса
}

// MARK: - Analyzed Instructions
struct AnalyzedInstruction: Codable, Identifiable {
    let name: String?                       // Название группы инструкций
    let steps: [InstructionStep]?           // Список шагов приготовления
    
    var id: String { name ?? UUID().uuidString }
}

// MARK: - InstructionStep Model
struct InstructionStep: Codable, Identifiable {
    let number: Int                         // Номер шага
    let step: String                        // Описание шага
    let ingredients: [InstructionIngredient]? // Ингредиенты для этого шага
    let equipment: [InstructionEquipment]?  // Необходимое оборудование
    let length: InstructionLength?          // Длительность шага
    
    var id: Int { number }
}

// MARK: - InstructionIngredient Model
struct InstructionIngredient: Codable, Identifiable {
    let id: Int                             // ID ингредиента
    let name: String                        // Название ингредиента
    let localizedName: String?              // Локализованное название
    let image: String?                      // Изображение ингредиента
}

// MARK: - InstructionEquipment Model
struct InstructionEquipment: Codable, Identifiable {
    let id: Int                             // ID оборудования
    let name: String                        // Название оборудования
    let localizedName: String?              // Локализованное название
    let image: String?                      // Изображение оборудования
}

// MARK: - InstructionLength Model
struct InstructionLength: Codable {
    let number: Int                         // Количество времени
    let unit: String                        // Единица времени (минуты, часы)
}

// MARK: - Preview Support
#if DEBUG
extension Recipe {
    static let preview = Recipe(
        id: 716429,
        image: "https://img.spoonacular.com/recipes/716429-556x370.jpg",
        imageType: "jpg",
        title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
        readyInMinutes: 45,
        servings: 2,
        sourceUrl: "https://fullbellysisters.blogspot.com/2012/06/pasta-with-garlic-scallions-cauliflower.html",
        vegetarian: false,
        vegan: false,
        glutenFree: false,
        dairyFree: false,
        veryHealthy: false,
        cheap: false,
        veryPopular: false,
        sustainable: false,
        lowFodmap: false,
        weightWatcherSmartPoints: 16,
        gaps: "no",
        preparationMinutes: 20,
        cookingMinutes: 25,
        aggregateLikes: 209,
        healthScore: 18.0,
        creditsText: "Full Belly Sisters",
        license: "CC BY-SA 3.0",
        sourceName: "Full Belly Sisters",
        pricePerServing: 157.06,
        extendedIngredients: [Ingredient.preview],
        nutrition: Nutrition.preview,
        summary: "Delicious pasta recipe...",
        cuisines: [],
        dishTypes: ["side dish", "lunch", "main course", "main dish", "dinner"],
        diets: [],
        occasions: [],
        instructions: "",
        analyzedInstructions: [],
        spoonacularScore: 83.91,
        spoonacularSourceUrl: "https://spoonacular.com/pasta-with-garlic-scallions-cauliflower-breadcrumbs-716429"
    )
}

extension Ingredient {
    static let preview = Ingredient(
        id: 1001,
        aisle: "Milk, Eggs, Other Dairy",
        image: "butter-sliced.jpg",
        consistency: "SOLID",
        name: "butter",
        nameClean: "butter",
        original: "1 tbsp butter",
        originalName: "butter",
        amount: 1.0,
        unit: "tbsp",
        meta: [],
        measures: Measures.preview
    )
}

extension Measures {
    static let preview = Measures(
        us: MeasureUnit(amount: 1.0, unitShort: "Tbsp", unitLong: "Tbsp"),
        metric: MeasureUnit(amount: 1.0, unitShort: "Tbsp", unitLong: "Tbsp")
    )
}

extension Nutrition {
    static let preview = Nutrition(
        nutrients: [
            Nutrient(name: "Calories", amount: 543.36, unit: "kcal", percentOfDailyNeeds: 27.17)
        ],
        caloricBreakdown: CaloricBreakdown(percentProtein: 12.29, percentFat: 26.61, percentCarbs: 61.1),
        weightPerServing: WeightPerServing(amount: 259, unit: "g")
    )
}
#endif
