import Foundation

// MARK: - Recipe Model
struct Recipe: Codable, Identifiable, Hashable {
  
    // MARK: - Основная информация
    var id: Int                                    // Уникальный ID рецепта
    var image: String?                             // URL изображения рецепта
    var imageType: String?                         // Тип изображения (jpg, png и т.д.)
    var title: String                              // Название рецепта
    var readyInMinutes: Int                        // Общее время приготовления (мин)
    var servings: Int                              // Количество порций
    var sourceUrl: String?                         // Ссылка на оригинальный рецепт
    
    // MARK: - Особенности диеты
    var vegetarian: Bool                           // Вегетарианский рецепт
    var vegan: Bool                                // Веганский рецепт
    var glutenFree: Bool                           // Без глютена
    var dairyFree: Bool                            // Без молочных продуктов
    var veryHealthy: Bool                          // Очень полезный
    var cheap: Bool                                // Дешевый в приготовлении
    var veryPopular: Bool                          // Очень популярный
    var sustainable: Bool                          // Экологически устойчивый
    var lowFodmap: Bool                            // Подходит для диеты FODMAP
    
    // MARK: - Дополнительная информация
    var weightWatcherSmartPoints: Int?             // Баллы Weight Watchers
    var gaps: String?                              // Соответствие диете GAPS
    var preparationMinutes: Int?                   // Время подготовки (мин)
    var cookingMinutes: Int?                       // Время готовки (мин)
    var aggregateLikes: Int                        // Количество лайков
    var healthScore: Double                        // Оценка полезности (0-100)
    var creditsText: String?                       // Информация об авторах
    var license: String?                           // Лицензия на рецепт
    var sourceName: String?                        // Название источника
    var pricePerServing: Double?                   // Цена за порцию (USD)
    
    // MARK: - Состав и инструкции
    var extendedIngredients: [Ingredient]?          // Список ингредиентов
    var nutrition: Nutrition?                      // Информация о питательности
    var summary: String?                           // Краткое описание рецепта
    var cuisines: [String]                         // Типы кухни (итальянская, китайская)
    var dishTypes: [String]                        // Типы блюд (закуска, основное)
    var diets: [String]                            // Подходящие диеты
    var occasions: [String]                        // Подходящие случаи (завтрак, ужин)
    var instructions: String?                      // Инструкции приготовления (текст)
    var analyzedInstructions: [AnalyzedInstruction] // Структурированные инструкции
    
    // MARK: - Оценки Spoonacular
    var spoonacularScore: Double                   // Внутренняя оценка качества
    var spoonacularSourceUrl: String               // URL в системе Spoonacular
}

// MARK: - Ingredient Model
struct Ingredient: Codable, Identifiable, Hashable {

    
    // MARK: - Основная информация
    var id: Int                     // Уникальный ID ингредиента
    var aisle: String?              // Отдел в магазине (молочный, мясной)
    var image: String?              // Название изображения ингредиента
    var consistency: String?        // Консистенция (жидкая, твердая)
    var name: String                // Название ингредиента
    var nameClean: String?          // Очищенное название без брендов
    var original: String            // Оригинальная строка из рецепта
    var originalName: String        // Оригинальное название
    
    // MARK: - Количество и единицы
    var amount: Double              // Количество
    var unit: String                // Единица измерения (стакан, ложка)
    var meta: [String]              // Дополнительная информация (нарезанный, свежий)
    var measures: Measures          // Единицы измерения (US/метрические)
}

// MARK: - Measures Model
struct Measures: Codable, Hashable {
    
    let us: MeasureUnit         // Американские единицы измерения
    let metric: MeasureUnit     // Метрические единицы измерения
}

// MARK: - MeasureUnit Model
struct MeasureUnit: Codable, Hashable {
    let amount: Double          // Количество в данной системе мер
    let unitShort: String       // Краткое название единицы (г, мл)
    let unitLong: String        // Полное название единицы (граммы, миллилитры)
}

// MARK: - Nutrition Model
struct Nutrition: Codable, Hashable {

    let nutrients: [Nutrient]               // Список питательных веществ
    let caloricBreakdown: CaloricBreakdown? // Распределение калорий по БЖУ
    let weightPerServing: WeightPerServing? // Вес одной порции
}

// MARK: - Nutrient Model
struct Nutrient: Codable, Identifiable, Hashable {
    let name: String                        // Название нутриента (Calories, Protein)
    let amount: Double                      // Количество
    let unit: String                        // Единица измерения (g, mg, kcal)
    let percentOfDailyNeeds: Double?        // Процент от дневной нормы
    
    var id: String { name }
}

// MARK: - CaloricBreakdown Model
struct CaloricBreakdown: Codable, Hashable {
    let percentProtein: Double              // Процент калорий из белков
    let percentFat: Double                  // Процент калорий из жиров
    let percentCarbs: Double                // Процент калорий из углеводов
}

// MARK: - WeightPerServing Model
struct WeightPerServing: Codable, Hashable {
    let amount: Double                      // Количество
    let unit: String                        // Единица измерения веса
}

// MARK: - Analyzed Instructions
struct AnalyzedInstruction: Codable, Identifiable, Hashable {
    
    let name: String?                       // Название группы инструкций
    let steps: [InstructionStep]?           // Список шагов приготовления
    
    var id: String { name ?? UUID().uuidString }
}

// MARK: - InstructionStep Model
struct InstructionStep: Codable, Identifiable, Hashable {
    let number: Int                         // Номер шага
    let step: String                        // Описание шага
    let ingredients: [InstructionIngredient]? // Ингредиенты для этого шага
    let equipment: [InstructionEquipment]?  // Необходимое оборудование
    let length: InstructionLength?          // Длительность шага
    
    var id: Int { number }
}

// MARK: - InstructionIngredient Model
struct InstructionIngredient: Codable, Identifiable, Hashable {
    let id: Int                             // ID ингредиента
    let name: String                        // Название ингредиента
    let localizedName: String?              // Локализованное название
    let image: String?                      // Изображение ингредиента
}

// MARK: - InstructionEquipment Model
struct InstructionEquipment: Codable, Identifiable, Hashable {
    let id: Int                             // ID оборудования
    let name: String                        // Название оборудования
    let localizedName: String?              // Локализованное название
    let image: String?                      // Изображение оборудования
}

// MARK: - InstructionLength Model
struct InstructionLength: Codable, Hashable {
    let number: Int                         // Количество времени
    let unit: String                        // Единица времени (минуты, часы)
}

// MARK: - Factory Methods
extension Recipe {
    static func createEmpty() -> Recipe {
        return Recipe(
            id: Int.random(in: 1000000...9999999),
            image: nil,
            imageType: nil,
            title: "",
            readyInMinutes: 20,
            servings: 1,
            sourceUrl: nil,
            vegetarian: false,
            vegan: false,
            glutenFree: false,
            dairyFree: false,
            veryHealthy: false,
            cheap: false,
            veryPopular: false,
            sustainable: false,
            lowFodmap: false,
            weightWatcherSmartPoints: nil,
            gaps: nil,
            preparationMinutes: nil,
            cookingMinutes: 20,
            aggregateLikes: 0,
            healthScore: 0.0,
            creditsText: "User created",
            license: "User license",
            sourceName: "User",
            pricePerServing: nil,
            extendedIngredients: [],
            nutrition: nil,
            summary: "",
            cuisines: [],
            dishTypes: [],
            diets: [],
            occasions: [],
            instructions: "",
            analyzedInstructions: [],
            spoonacularScore: 0.0,
            spoonacularSourceUrl: ""
        )
    }
}

extension Ingredient {
    static func createEmpty() -> Ingredient {
        return Ingredient(
            id: Int.random(in: 1...1000000),
            aisle: nil,
            image: nil,
            consistency: nil,
            name: "",
            nameClean: "",
            original: "",
            originalName: "",
            amount: 1.0,
            unit: "piece",
            meta: [],
            measures: Measures(
                us: MeasureUnit(amount: 1.0, unitShort: "pc", unitLong: "piece"),
                metric: MeasureUnit(amount: 1.0, unitShort: "шт", unitLong: "штука")
            )
        )
    }
}
