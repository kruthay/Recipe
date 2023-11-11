//
//  FoodDatabaseAPI.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation

/// API is a protocol that requires a `String` with baseURL
protocol API {
    static var baseURLString: String { get }
}


/// FoodDatabaseAPI is a enum, that's conformed to `API` protocol & `RawRepresentable` protocol,
/// `RawRepresentable` protocol is used for cleaner ussage of the base URL
/// FootDatabaseAPI has four cases, other required cases can be added based on the complexity of the API and the application
enum FoodDatabaseAPI: API, RawRepresentable {
    init?(rawValue: String) { nil }
    var rawValue: String {
        switch self {
        case .getCategoriesDetails: return "categories.php"
        case .getMealWith(let id): return "lookup.php?i=\(id)"
        case .getMealsFrom(let category): return "filter.php?c=\(category)"
        case .getListOfCategories: return "list.php?c=list"
        }
    }

    static let baseURLString = "https://www.themealdb.com/api/json/v1/1/"
    
    /// to get means with id given as `Int`

    case getMealWith(id: Int)
    
    /// to get categories and their details such as descritption
    case getCategoriesDetails
    
    /// to just get the list of categories, can be used with `getMealsFrom(category: String)` to get speicific category meals
    case getListOfCategories
    
    /// In this app, only "Dessert" is required, but any value can be used to get the food values
    case getMealsFrom(category: String)
}


/// used to get a url value from rawValue and baseURLString strings concatenated  

extension RawRepresentable where Self: API, RawValue == String {
    var url: URL? { URL(string: Self.baseURLString + rawValue) }
}
