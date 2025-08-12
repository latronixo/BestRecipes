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
    func fetchRecipeInformation(id: Int, includeNutrition: Bool = true) async throws -> Recipe {
        let endpoint = APIConfig.Endpoint.recipeInformation(id: id, includeNutrition: includeNutrition)
        return try await fetchData(endpoint, as: Recipe.self)
    }
    
    // MARK: - Search Recipes
    /// Поиск рецептов по запросу
    func searchRecipes(query: String, numberOfResults: Int = 10) async throws -> RecipeSearchResponse {
        let endpoint = APIConfig.Endpoint.searchRecipes(query: query, number: numberOfResults)
        return try await fetchData(endpoint, as: RecipeSearchResponse.self)
    }
    
    // MARK: - Cuisine Search
    /// Поиск рецептов по типу кухни
    func searchRecipesByCuisine(_ cuisine: CuisineType, numberOfResults: Int = 10) async throws -> RecipeSearchResponse {
        let endpoint = APIConfig.Endpoint.searchByCuisine(cuisine: cuisine, number: numberOfResults)
        return try await fetchData(endpoint, as: RecipeSearchResponse.self)
    }
    
    // MARK: - Random Recipes
    /// Получает случайные рецепты
    func fetchRandomRecipes(numberOfRecipes: Int = 1) async throws -> RandomRecipesResponse {
        let endpoint = APIConfig.Endpoint.randomRecipes(number: numberOfRecipes)
        return try await fetchData(endpoint, as: RandomRecipesResponse.self)
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
    
    // MARK: - Recipe Image Operations
    /// Загружает изображение рецепта
    func fetchRecipeImageData(_ recipe: Recipe, size: String? = nil) async throws -> Data? {
        guard let imageURL = recipe.image else { return nil }
        
        let finalURL: String
        if let size = size {
            finalURL = imageURL.replacingOccurrences(of: "556x370", with: size)
        } else {
            finalURL = imageURL
        }
        
        return try await fetchImageData(from: finalURL)
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
    
    // MARK: - Generic Network Operations
    func fetchData<T: Codable>(_ endpoint: APIConfig.Endpoint, as responseType: T.Type) async throws -> T {
        let url = try buildURL(for: endpoint)
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        do {
            return try decoder.decode(responseType, from: data)
        } catch {
            throw NetworkError.decodingError(error)
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
