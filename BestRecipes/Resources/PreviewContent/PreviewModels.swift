//
//  PreviewModels.swift
//  BestRecipes
//
//  Создано для хранения превью-данных моделей отдельно от основных моделей.
//

import Foundation

#if DEBUG

// MARK: - Recipe Preview
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

// MARK: - Ingredient Preview
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

// MARK: - Measures Preview
extension Measures {
    static let preview = Measures(
        us: MeasureUnit(amount: 1.0, unitShort: "Tbsp", unitLong: "Tbsp"),
        metric: MeasureUnit(amount: 1.0, unitShort: "Tbsp", unitLong: "Tbsp")
    )
}

// MARK: - Nutrition Preview
extension Nutrition {
    static let preview = Nutrition(
        nutrients: [
            Nutrient(name: "Calories", amount: 543.36, unit: "kcal", percentOfDailyNeeds: 27.17)
        ],
        caloricBreakdown: CaloricBreakdown(percentProtein: 12.29, percentFat: 26.61, percentCarbs: 61.1),
        weightPerServing: WeightPerServing(amount: 259, unit: "g")
    )
}

// MARK: - AnalyzedInstruction Preview
extension AnalyzedInstruction {
    static let preview = AnalyzedInstruction(
        name: "",
        steps: [
            InstructionStep(number: 1, step: "Step number one", ingredients: [], equipment: [], length: InstructionLength(number: 15, unit: "min")),
            InstructionStep(number: 2, step: "Step number two  dfg dfg dfg ertwertwr wsfgwrt sfsfwtwdfg werff", ingredients: [], equipment: [], length: nil),
            InstructionStep(number: 3, step: "Step number three", ingredients: [], equipment: [], length: InstructionLength(number: 15, unit: "min")),
            InstructionStep(number: 4, step: "Step number four", ingredients: [], equipment: [], length: nil)
        ]
    )
}

#endif


