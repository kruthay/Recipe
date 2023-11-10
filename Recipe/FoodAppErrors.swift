//
//  FoodAppErrors.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation
enum FoodAppErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidFoodDetailedData(error: Error)
    case invalidDetailsData(error: Error)
    case invalidIngredientsData(error: Error)
    case invalidId
    case invalidData(error: Error)
    case dynamicKeyError(error: Error)
    case codingKeyError(error: Error)
}
