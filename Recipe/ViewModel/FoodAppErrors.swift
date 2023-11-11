//
//  FoodAppErrors.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation
enum FoodAppErrors: Error {
    /// can be used with bad url's
    case invalidURL
    
    /// can be used when any response other than 200
    case invalidResponse
    
    /// can be used to when retriving long details of food
    case invalidFoodDetailedData(error: Error)
    
    /// can be used for other details such as Category
    case invalidDetailsData(error: Error)
    
    /// can be used for invalid ingredients
    case invalidIngredientsData(error: Error)
    
    
    /// can be used when `Int` is not given as id
    case invalidId
    
    /// can be used with invalid Data
    case invalidData(error: Error)
    
    /// can be used for dynamic coding keys
    case dynamicKeyError(error: Error)
    
    /// can be used for simpler coding keys
    case codingKeyError(error: Error)
}
