//
//  FoodDatabaseAPI.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation


protocol API {
    static var baseURLString: String { get }
}

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

    case getMealWith(id: Int)
    case getCategoriesDetails
    case getListOfCategories
    case getMealsFrom(category: String)
}

extension RawRepresentable where Self: API, RawValue == String {
    var url: URL? { URL(string: Self.baseURLString + rawValue) }
}
