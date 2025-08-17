//
//  NetworkError.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import Foundation

// MARK: - Network Error Types
enum NetworkError: LocalizedError {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
    case invalidResponse
    case serverError(Int)
    case imageError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Недействительный URL"
        case .decodingError(let error):
            return "Ошибка декодирования данных: \(error.localizedDescription)"
        case .networkError(let error):
            return "Сетевая ошибка: \(error.localizedDescription)"
        case .invalidResponse:
            return "Недействительный ответ сервера"
        case .serverError(let statusCode):
            return "Ошибка сервера: \(statusCode)"
        case .imageError:
            return "Ошибка загрузки изображения"
        }
    }
}

// MARK: - Cuisine Types
enum CuisineType: String, CaseIterable {
    case italian = "italian"
    case european = "european"
    case french = "french"
    case spanish = "spanish"
    case german = "german"
    case greek = "greek"
    case mediterranean = "mediterranean"
    case asian = "asian"
    case chinese = "chinese"
    case japanese = "japanese"
    case thai = "thai"
    case indian = "indian"
    case korean = "korean"
    case vietnamese = "vietnamese"
    case mexican = "mexican"
    case american = "american"
    case southern = "southern"
    case cajun = "cajun"
    case caribbean = "caribbean"
    case african = "african"
    case middleEastern = "middle eastern"
    case jewish = "jewish"
}

// MARK: - Recipe Categories
enum RecipeCategory: String, CaseIterable {
    case mainCourse = "main course"
    case appetizer = "appetizer"
    case dessert = "dessert"
    case salad = "salad"
    case soup = "soup"
    case beverage = "beverage"
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case sideDish = "side dish"
    case snack = "snack"
}

// MARK: - API Configuration
struct APIConfig {
    static let baseURL = "https://api.spoonacular.com"
    static let imageBaseURL = "https://img.spoonacular.com"
    
    enum ImageURLs {
        static let ingredient = "ingredients_100x100/"
        static let equipment = "equipment_100x100/"
    }
    
    enum Endpoint {
        case recipeInformation(id: Int, includeNutrition: Bool = true)
        case searchRecipes(query: String, number: Int = 10)
        case randomRecipes(number: Int = 1)
        case searchByCuisine(cuisine: CuisineType, number: Int = 10)
        case searchByCategory(category: String, number: Int = 10)
        
        var path: String {
            switch self {
            case .recipeInformation(let id, _):
                return "/recipes/\(id)/information"
            case .randomRecipes:
                return "/recipes/random"
            default:
                return "/recipes/complexSearch"
            }
        }
        
        var queryItems: [URLQueryItem] {
            var items = [URLQueryItem(name: "apiKey", value: Secrets.apiKey)]
            
            switch self {
            case .recipeInformation(_, let includeNutrition):
                items.append(URLQueryItem(name: "includeNutrition", value: "\(includeNutrition)"))
                
            case .searchRecipes(let query, let number):
                items.append(URLQueryItem(name: "query", value: query))
                items.append(contentsOf: Self.buildSearchQueryItems(number))
                
            case .searchByCuisine(let cuisine, let number):
                items.append(URLQueryItem(name: "cuisine", value: cuisine.rawValue))
                items.append(contentsOf: Self.buildSearchQueryItems(number))
                
            case .randomRecipes(let number):
                items.append(URLQueryItem(name: "number", value: "\(number)"))
                
            case .searchByCategory(category: let category, number: let number):
                items.append(URLQueryItem(name: "type", value: category))
                items.append(contentsOf: Self.buildSearchQueryItems(number))
            }
            
            return items
        }
        
        private static func buildSearchQueryItems(_ number: Int) -> [URLQueryItem] {
            return [
                URLQueryItem(name: "number", value: "\(number)"),
                URLQueryItem(name: "addRecipeInformation", value: "true")
            ]
        }
    }
}

