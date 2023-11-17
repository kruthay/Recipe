//
//  FoodValuesCollection.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//
import Foundation
import SwiftData

/// FoodValuesCollection is a struct mainly used for bridging JSON data API with SwiftData Model.
struct FoodValuesCollection: Codable {
    
    /// `meals` is the outer contianer of the API's JSON object
    let meals: [FoodInfo]
    
    /// Used to decode the inner container information about food
    struct FoodInfo: Codable {
        
        /// API's id is made of String but it's typecasted for convinience. This has to be available to conform to `Identifiable`
        let id : Int
        
        /// strMeal is the name of the string, can be optional
        let meal : String?
        
        /// strInstructions are present only in the detailed API
        let instructions: String?
        
        /// used to get the image url
        let thumbnailImageURL: URL?
        
        /// the ingredients and measures are given as 20 different values for each. This property stores all those values from the API
        var ingredientsAndMeasures : [String : String]
        
        /// CodingKeys enum is for non-dynamic simple API container keys.
        private enum CodingKeys: String, CodingKey {
            case id = "idMeal"
            case meal = "strMeal"
            case instructions = "strInstructions"
            case thumbnailImageURL = "strMealThumb"
        }
        
        /// DynamicCodingKeys are for ingredients and measures.
        /// Ingredients and Measures are `String` and hence `int` failable init is not used
        private struct DynamicCodingKeys: CodingKey {
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            var intValue: Int?
            init?(intValue: Int) {
                return nil
            }
        }
        
        /// the init is used by the `JSONDecoder` to retrieve the values based on the keys
        init(from decoder: Decoder) throws {
            do {
                
                /// `container` is used for simpler regular keys, that are available with the same value in the API
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                let idMeal = try container.decode(String.self, forKey: .id)
                if let id = Int(idMeal) {
                    self.id = id
                } else {
                    throw FoodAppErrors.invalidId
                }
                
                self.meal = try container.decodeIfPresent(String.self, forKey: .meal)
                self.instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
                self.thumbnailImageURL = try container.decodeIfPresent(URL.self, forKey: .thumbnailImageURL)
            }
            catch {
                throw FoodAppErrors.codingKeyError(error: error)
            }
            
            
            do {
                /// the `dynamicValuesContainer` is keyed using `DynamicCodingKeys` to get the dynamic values for measures and ingredients
                let dynamicValuesContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
                var ingredients : [Int : String] = [:]
                var measures : [Int : String] = [:]
                var ingredientsAndMeasures : [String : String] = [:]
                
                for key in dynamicValuesContainer.allKeys {
                    if let keyIterator = getIntValueFromStringSuffix(stringValue: key.stringValue) {
                        
                        if let value = try? dynamicValuesContainer.decode(String.self, forKey: key) {
                            if !value.isEmpty {
                                if key.stringValue.hasPrefix("strMeasure") {
                                    measures[keyIterator] = value
                                }
                                else  if key.stringValue.hasPrefix("strIngredient") {
                                    ingredients[keyIterator] = value
                                }
                            }
                        }
                    }
                }
                /// Dictionary of ingredients and values is formed and initialised
                for key in measures.keys {
                    if let ingredient = ingredients[key] {
                        if ingredient.isEmpty {
                            continue
                        }
                        if let measure = measures[key] {
                            if measure.isEmpty {
                                continue
                            }
                            ingredientsAndMeasures[ingredient] = measure
                        }
                    }
                }
                self.ingredientsAndMeasures = ingredientsAndMeasures
            }
            catch {
                throw FoodAppErrors.dynamicKeyError(error: error)
            }
        }
        
    }
}


/// Extension to confrorm to identifiable, if changes are needed in the future
extension FoodValuesCollection.FoodInfo : Identifiable {}


/// This extension consits of various static methods to fetchvalues and to help with initialisation
extension FoodValuesCollection {


    
}

extension FoodValuesCollection {
    /// Helper function to get the `Int?` value from last two or one character of a `String`
    /// a static function `getIntValueFromStringSuffix(stringValue:String)` is used to get the incremental value at the end of eachKey and the values for ingredients and measures.
    /// prefix and suffix values are used to get the ingredient and measure values
    /// Please check the API for more details
    /// - Parameters:
    ///    - stringValue: a String which could contain last two values as numeric
    /// - Returns: the integer value at the end of the string.

     static func getIntValueFromStringSuffix(stringValue: String) -> Int? {
        if let intValue = Int(stringValue.suffix(2)) {
            return intValue
        } else if let intValue = Int(stringValue.suffix(1)) {
            return intValue
        }
        return nil
    }

}
