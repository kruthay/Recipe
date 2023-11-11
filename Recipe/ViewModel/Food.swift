//
//  Item.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation
import SwiftData

/// Used SwiftData to cache the API information and reduce Network requirement
/// Didn't cache the image in SwiftData as that is inefficient
/// I wasn't sure if Caching is required, so I avoided doing it for Images
@Model
class Food : Identifiable {
    /// ID used for the model
    @Attribute(.unique) var id: Int
    
    var name: String?
    
    var thumbnail: URL?
    
    var instructions: String?
    
    var ingredientsAndMeasurements: [String: String]
    
    
    init(id: Int, name: String?, thumbnail: URL?, instructions: String?, ingredientsAndMeasurements: [String : String]) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.instructions = instructions
        self.ingredientsAndMeasurements = ingredientsAndMeasurements
    }
}


/// convinience init is used to migrate the data from `FoodValuesCollection.FoodInfo` to the  `Food` model
extension Food {
    convenience init(from foodValues: FoodValuesCollection.FoodInfo) {
        self.init (
            id: foodValues.id,
            name: foodValues.strMeal,
            thumbnail: foodValues.strMealThumb,
            instructions: foodValues.strInstructions,
            ingredientsAndMeasurements: foodValues.strIngredientsAndMeasures
        )
    }
}
