//
//  FoodService.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/17/23.
//

import Foundation

protocol FoodServicable {
    func getMealsFrom(category: String) async throws -> FoodValuesCollection
    func getMealWith(id: Int) async throws -> FoodValuesCollection
}

struct FoodService : HTTPClient, FoodServicable {
    
    func getMealWith(id: Int) async throws -> FoodValuesCollection {
        return try await sendRequest(endpoint: FoodDatabaseEndPoint.getMealWith(id: id), responseModel: FoodValuesCollection.self)
    }
    
    func getMealsFrom(category: String ) async throws -> FoodValuesCollection {
        return try await sendRequest(endpoint: FoodDatabaseEndPoint.getMealsFrom(category: category), responseModel: FoodValuesCollection.self)
    }
    
}
