//
//  NetworkServices.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import Foundation

// MARK: - NetworkServices
final class NetworkServices {
    static let shared = NetworkServices()
    private init() {}
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let imageCache = NSCache<NSString, NSData>()
    
    // MARK: - Recipe Information
    /// Получает подробную информацию о рецепте по ID
    /// - Parameters:
    ///   - id: ID рецепта
    ///   - includeNutrition: Включать ли информацию о питательности
    /// - Returns: Модель Recipe
    func fetchRecipeInformation(id: Int, includeNutrition: Bool = true) async throws -> Recipe {
        let endpoint = APIConfig.Endpoint.recipeInformation(id: id, includeNutrition: includeNutrition)
        let url = try buildURL(for: endpoint)
        
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        do {
            let recipe = try decoder.decode(Recipe.self, from: data)
            return recipe
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Search Recipes
    /// Поиск рецептов по запросу
    /// - Parameters:
    ///   - query: Поисковый запрос
    ///   - numberOfResults: Количество результатов (по умолчанию 10)
    /// - Returns: Массив рецептов
    func searchRecipes(query: String, numberOfResults: Int = 10) async throws -> RecipeSearchResponse {
        let endpoint = APIConfig.Endpoint.searchRecipes(query: query, number: numberOfResults)
        let url = try buildURL(for: endpoint)
        
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        do {
            let searchResponse = try decoder.decode(RecipeSearchResponse.self, from: data)
            return searchResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Cuisine Search
    /// Поиск рецептов по типу кухни
    /// - Parameters:
    ///   - cuisine: Тип кухни (итальянская, французская, азиатская и т.д.)
    ///   - numberOfResults: Количество результатов (по умолчанию 10)
    /// - Returns: Ответ с найденными рецептами и метаданными
    func searchRecipesByCuisine(_ cuisine: CuisineType, numberOfResults: Int = 10) async throws -> RecipeSearchResponse {
        let endpoint = APIConfig.Endpoint.searchByCuisine(cuisine: cuisine, number: numberOfResults)
        let url = try buildURL(for: endpoint)
        
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        do {
            let searchResponse = try decoder.decode(RecipeSearchResponse.self, from: data)
            return searchResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Random Recipes
    /// Получает случайные рецепты
    /// - Parameter numberOfRecipes: Количество рецептов (по умолчанию 1)
    /// - Returns: Массив случайных рецептов
    func fetchRandomRecipes(numberOfRecipes: Int = 1) async throws -> RandomRecipesResponse {
        let endpoint = APIConfig.Endpoint.randomRecipes(number: numberOfRecipes)
        let url = try buildURL(for: endpoint)
        
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        do {
            let randomResponse = try decoder.decode(RandomRecipesResponse.self, from: data)
            return randomResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Image Operations
    /// Загружает изображение как Data с кэшированием
    func fetchImageData(from urlString: String) async throws -> Data {
        if let cachedData = imageCache.object(forKey: urlString as NSString) {
            return cachedData as Data
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        guard data.count > 0 else {
            throw NetworkError.invalidImageData
        }
        
        imageCache.setObject(data as NSData, forKey: urlString as NSString)
        
        return data
    }
    
    /// Загружает изображение рецепта
    func fetchRecipeImageData(_ recipe: Recipe) async throws -> Data? {
        guard let imageURL = recipe.image else { return nil }
        return try await fetchImageData(from: imageURL)
    }
    
    /// Загружает изображение рецепта определенного размера
    func fetchRecipeImageData(_ recipe: Recipe, size: String) async throws -> Data? {
        guard let imageURL = recipe.image else { return nil }
        let sizedURL = imageURL.replacingOccurrences(of: "556x370", with: size)
        return try await fetchImageData(from: sizedURL)
    }
    
    /// Загружает изображение ингредиента
    func fetchIngredientImageData(_ ingredient: Ingredient) async throws -> Data? {
        guard let imageName = ingredient.image else { return nil }
        return try await fetchImageData(from: imageName.ingredientImageURL)
    }
    
    /// Загружает изображение оборудования
    func fetchEquipmentImageData(_ equipment: InstructionEquipment) async throws -> Data? {
        guard let imageName = equipment.image else { return nil }
        return try await fetchImageData(from: imageName.equipmentImageURL)
    }
    
    /// Загружает изображения для списка рецептов
    func fetchRecipeImageData(_ recipes: [Recipe]) async throws -> [Int: Data] {
        var imagesData: [Int: Data] = [:]
        
        try await withThrowingTaskGroup(of: (Int, Data).self) { group in
            for recipe in recipes {
                guard let imageURL = recipe.image else { continue }
                
                group.addTask {
                    let data = try await self.fetchImageData(from: imageURL)
                    return (recipe.id, data)
                }
            }
            
            for try await (id, data) in group {
                imagesData[id] = data
            }
        }
        
        return imagesData
    }
    
    // MARK: - Cache Management
    /// Очищает кэш изображений
    func clearImageCache() {
        imageCache.removeAllObjects()
    }
    
    /// Устанавливает лимит кэша (по умолчанию 50MB)
    func setupImageCache(memoryLimit: Int = 50 * 1024 * 1024) {
        imageCache.totalCostLimit = memoryLimit
        imageCache.countLimit = 100 // максимум 100 изображений
    }
}

// MARK: - Private Helpers
private extension NetworkServices {
    func buildURL(for endpoint: APIConfig.Endpoint) throws -> URL {
        guard var urlComponents = URLComponents(string: APIConfig.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400...499, 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.invalidResponse
        }
    }
}

// MARK: - URL Building Extensions
private extension String {
    /// Формирует URL для изображения ингредиента
    var ingredientImageURL: String {
        "https://img.spoonacular.com/ingredients_100x100/\(self)"
    }
    
    /// Формирует URL для изображения оборудования
    var equipmentImageURL: String {
        "https://img.spoonacular.com/equipment_100x100/\(self)"
    }
}

// MARK: - Response Models
struct RecipeSearchResponse: Codable {
    let results: [Recipe]
    let offset: Int
    let number: Int
    let totalResults: Int
}

struct RandomRecipesResponse: Codable {
    let recipes: [Recipe]
}
