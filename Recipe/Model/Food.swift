//
//  Item.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import Foundation
import SwiftData

// Used SwiftData to cache the API information and reduce Network requirement
// Didn't cache the image in SwiftData as that is inefficient and AsyncImage has default Caching enabled

/// `Food` class is used as a model for the `SwiftData`
///  This class acts as the source of Truth for the view
@Model
class Food : Identifiable {
    /// `id` used for the `Food` class.
    /// `id` is required for the `Food` class to be identifiable
    /// `id` is also a `@Attribute(.unique)`
    @Attribute(.unique) var id: Int
    
    /// `name` is an `Optional String` to store the name of the `Food` Type
    var name: String?
    
    /// `thumbnail` consits of an `Optional URL` to store the URL location of the `Image`
    var thumbnail: URL?
    
    /// `instructions` is a `Optional String` that stores how to make the food
    var instructions: String?
    
    /// `ingredientsAndMeasurements` is a `Dictionary` with `ingredients` as keys and respective `measurements` as values.
    /// It could be empty
    var ingredientsAndMeasurements: [String: String]
    
    /// default initialiser for the `Food` class
    init(id: Int, name: String?, thumbnail: URL?, instructions: String?, ingredientsAndMeasurements: [String : String]) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.instructions = instructions
        self.ingredientsAndMeasurements = ingredientsAndMeasurements
    }
}


/// The extension adds convinience init, which is used to migrate the data from `FoodValuesCollection.FoodInfo` to the  `Food` model
extension Food {
    /// The convenience init calls the default init using the data from `FoodValuesCollection.FoodInfo`
    /// - Parameters:
    ///     - foodValues: The data typically initialised from the JSON object
    convenience init(from foodValues: FoodValuesCollection.FoodInfo) {
        self.init (
            id: foodValues.id,
            name: foodValues.meal,
            thumbnail: foodValues.thumbnailImageURL,
            instructions: foodValues.instructions,
            ingredientsAndMeasurements: foodValues.ingredientsAndMeasures
        )
    }
}
