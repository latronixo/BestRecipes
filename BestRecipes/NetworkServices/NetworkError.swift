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
    case noData
    case decodingError(Error)
    case networkError(Error)
    case invalidResponse
    case serverError(Int)
    case apiKeyMissing
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Недействительный URL"
        case .noData:
            return "Нет данных в ответе"
        case .decodingError(let error):
            return "Ошибка декодирования данных: \(error.localizedDescription)"
        case .networkError(let error):
            return "Сетевая ошибка: \(error.localizedDescription)"
        case .invalidResponse:
            return "Недействительный ответ сервера"
        case .serverError(let statusCode):
            return "Ошибка сервера: \(statusCode)"
        case .apiKeyMissing:
            return "API ключ отсутствует"
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
    
    var displayName: String {
        switch self {
        case .italian: return "Итальянская"
        case .european: return "Европейская"
        case .french: return "Французская"
        case .spanish: return "Испанская"
        case .german: return "Немецкая"
        case .greek: return "Греческая"
        case .mediterranean: return "Средиземноморская"
        case .asian: return "Азиатская"
        case .chinese: return "Китайская"
        case .japanese: return "Японская"
        case .thai: return "Тайская"
        case .indian: return "Индийская"
        case .korean: return "Корейская"
        case .vietnamese: return "Вьетнамская"
        case .mexican: return "Мексиканская"
        case .american: return "Американская"
        case .southern: return "Южноамериканская"
        case .cajun: return "Каджунская"
        case .caribbean: return "Карибская"
        case .african: return "Африканская"
        case .middleEastern: return "Ближневосточная"
        case .jewish: return "Еврейская"
        }
    }
}

// MARK: - API Configuration
struct APIConfig {
    static let apiKey = "a1df0d471f714100b58221af46a5cb2c"
    static let baseURL = "https://api.spoonacular.com"
    
    enum Endpoint {
        case recipeInformation(id: Int, includeNutrition: Bool = true)
        case searchRecipes(query: String, number: Int = 10)
        case randomRecipes(number: Int = 1)
        case searchByCuisine(cuisine: CuisineType, number: Int = 10)
        
        var path: String {
            switch self {
            case .recipeInformation(let id, _):
                return "/recipes/\(id)/information"
            case .searchRecipes, .searchByCuisine:
                return "/recipes/complexSearch"
            case .randomRecipes:
                return "/recipes/random"
            }
        }
        
        var queryItems: [URLQueryItem] {
            var items = [URLQueryItem(name: "apiKey", value: APIConfig.apiKey)]
            
            switch self {
            case .recipeInformation(_, let includeNutrition):
                items.append(URLQueryItem(name: "includeNutrition", value: "\(includeNutrition)"))
                
            case .searchRecipes(let query, let number):
                items.append(contentsOf: [
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "number", value: "\(number)"),
                    URLQueryItem(name: "addRecipeInformation", value: "true")
                ])
                
            case .searchByCuisine(let cuisine, let number):
                items.append(contentsOf: [
                    URLQueryItem(name: "cuisine", value: cuisine.rawValue),
                    URLQueryItem(name: "number", value: "\(number)"),
                    URLQueryItem(name: "addRecipeInformation", value: "true")
                ])
                
            case .randomRecipes(let number):
                items.append(URLQueryItem(name: "number", value: "\(number)"))
            }
            
            return items
        }
    }
}
