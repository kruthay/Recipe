//
//  FoodDatabaseAPI.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation


enum FoodDatabaseEndPoint {
    case getMealWith(id: Int)
    
    /// to get categories and their details such as descritption
    case getCategoriesDetails
    
    /// to just get the list of categories, can be used with `getMealsFrom(category: String)` to get speicific category meals
    case getListOfCategories
    
    /// In this app, only "Dessert" is required, but any value can be used to get the food values
    case getMealsFrom(category: String)
}

extension FoodDatabaseEndPoint : EndPoint {

    var path: String {
        return switch self {
            
            case .getMealWith(_):
                "/api/json/v1/1/lookup.php"
            
            case .getCategoriesDetails:
                "/api/json/v1/1/categories.php"
            
            case .getListOfCategories:
                "/api/json/v1/1/list.php"
            
            case .getMealsFrom(_):
                "/api/json/v1/1/filter.php"
            
        }
    }
    
    var method: RequestMethod? {
        return nil
    }
    
    var header: [String : String]? {
        return nil
    }
    
    var body: [String : String]? {
        return nil
    }
    
    var queryItem: URLQueryItem? {
        return switch self {
            
            case .getMealWith(id: let id):
                URLQueryItem(name: "i", value: String(id))
            
            case .getCategoriesDetails:
                nil
            
            case .getListOfCategories:
                URLQueryItem(name: "c", value: "list")
            
            case .getMealsFrom(category: let category):
                URLQueryItem(name: "c", value: category)
        }
    }
    
}
