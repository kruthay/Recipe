//
//  Item.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation
import SwiftData

@Model
class Food : Identifiable {
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
