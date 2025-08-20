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
    
    // MARK: - Recipe Network Operations
    /// Получает подробную информацию о рецепте по ID
    func fetchRecipeInformation(id: Int, includeNutrition: Bool = true) async throws -> Recipe {
        let endpoint = APIConfig.Endpoint.recipeInformation(id: id, includeNutrition: includeNutrition)
        return try await fetchData(endpoint, as: Recipe.self)
    }
    
    /// Поиск рецептов по запросу
    func searchRecipes(query: String, numberOfResults: Int = 10) async throws -> [Recipe] {
        let endpoint = APIConfig.Endpoint.searchRecipes(query: query, number: numberOfResults)
        let response = try await fetchData(endpoint, as: RecipesResponse.self)
        return response.results
    }
    
    /// Поиск рецептов по типу кухни
    func searchRecipesByCuisine(_ cuisine: CuisineType, numberOfResults: Int = 10) async throws -> [Recipe] {
        let endpoint = APIConfig.Endpoint.searchByCuisine(cuisine: cuisine, number: numberOfResults)
        let response = try await fetchData(endpoint, as: SearchRecipesResponse.self)
        return response.results
    }
    
    /// Получает случайные рецепты
    func fetchRandomRecipes(numberOfRecipes: Int = 1) async throws -> [Recipe] {
        let endpoint = APIConfig.Endpoint.randomRecipes(number: numberOfRecipes)
        let response = try await fetchData(endpoint, as: RandomRecipesResponse.self)
        return response.recipes
    }
    
    /// Поиск рецептов по категориям
    func searchRecipesByCategory(_ category: RecipeCategory, numberOfResults: Int = 10) async throws -> [Recipe] {
        let endpoint = APIConfig.Endpoint.searchByCategory(category: category.rawValue, number: numberOfResults)
        let response = try await fetchData(endpoint, as: SearchRecipesResponse.self)
        return response.results
    }
    
    // MARK: - Image Loading Operations
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

    /// Загружает изображение ингредиента
    func fetchIngredientImageData(_ ingredient: Ingredient) async throws -> Data? {
        guard let imageName = ingredient.image else { return nil }
        let imageURL = APIConfig.imageBaseURL + APIConfig.ImageURLs.ingredient + imageName
        return try await fetchImageData(from: imageURL)
    }

    /// Загружает изображение оборудования
    func fetchEquipmentImageData(_ equipment: InstructionEquipment) async throws -> Data? {
        guard let imageName = equipment.image else { return nil }
        let imageURL = APIConfig.imageBaseURL + APIConfig.ImageURLs.equipment + imageName
        return try await fetchImageData(from: imageURL)
    }
    
    // MARK: - Cache Management
    /// Очищает кэш изображений
    func configureImageCache(memoryLimit: Int = 50 * 1024 * 1024, clearExisting: Bool = false) {
        if clearExisting {
            imageCache.removeAllObjects()
        }
        imageCache.totalCostLimit = memoryLimit
        imageCache.countLimit = 100
    }
}

// MARK: - Private Network Helpers
private extension NetworkServices {
    func buildURL(for endpoint: APIConfig.Endpoint) throws -> URL {
        guard let urlComponents = URLComponents(string: APIConfig.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var mutableComponents = urlComponents
        mutableComponents.queryItems = endpoint.queryItems
        
        guard let url = mutableComponents.url else {
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
    
    /// Базовая загрузка изображения с кэшированием
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
            throw NetworkError.imageError
        }
        
        imageCache.setObject(data as NSData, forKey: urlString as NSString)
        return data
    }
}
