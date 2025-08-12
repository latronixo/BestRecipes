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
