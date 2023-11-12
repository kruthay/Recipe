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
        let strMeal : String?
        
        /// strInstructions are present only in the detailed API
        let strInstructions: String?
        
        /// used to get the image url
        let strMealThumb: URL?
        
        /// the ingredients and measures are given as 20 different values for each. This property stores all those values from the API
        var strIngredientsAndMeasures : [String : String]
        
        /// CodingKeys enum is for non-dynamic simple API container keys.
        private enum CodingKeys: String, CodingKey {
            case id = "idMeal"
            case strMeal
            case strInstructions
            case strMealThumb
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
                
                self.strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
                self.strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
                self.strMealThumb = try container.decodeIfPresent(URL.self, forKey: .strMealThumb)
            }
            catch {
                throw FoodAppErrors.codingKeyError(error: error)
            }
            
            
            do {
                /// the `dynamicValuesContainer` is keyed using `DynamicCodingKeys` to get the dynamic values for measures and ingredients
                let dynamicValuesContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
                var strIngredients : [Int : String] = [:]
                var strMeasures : [Int : String] = [:]
                var strIngredientsAndMeasures : [String : String] = [:]
                
                for key in dynamicValuesContainer.allKeys {
                    if let keyIterator = getIntValueFromStringSuffix(stringValue: key.stringValue) {
                        
                        if let value = try? dynamicValuesContainer.decode(String.self, forKey: key) {
                            if !value.isEmpty {
                                if key.stringValue.hasPrefix("strMeasure") {
                                    strMeasures[keyIterator] = value
                                }
                                else  if key.stringValue.hasPrefix("strIngredient") {
                                    strIngredients[keyIterator] = value
                                }
                            }
                        }
                    }
                }
                
                /// Dictionary of ingredients and values is formed and initialised
                for key in strMeasures.keys {
                    if let ingredient = strIngredients[key] {
                        if ingredient.isEmpty {
                            continue
                        }
                        if let measure = strMeasures[key] {
                            if measure.isEmpty {
                                continue
                            }
                            strIngredientsAndMeasures[ingredient] = measure
                        }
                    }
                }
                self.strIngredientsAndMeasures = strIngredientsAndMeasures
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
    
    /// This static method fetches meal values of the category and returns the `Array<FoodInfo>`
    /// - Parameters:
    ///    - category: `String` with a default value of "Dessert"
    /// - Returns: Array of meals in the given category.
    static func fetchBriefMealValues(_ category: String = "Dessert") async throws -> [FoodInfo] {
        guard let baseURL = FoodDatabaseAPI.getMealsFrom(category: category).url else {
            throw FoodAppErrors.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FoodAppErrors.invalidResponse
        }
        do {
            let decodedResponse = try JSONDecoder().decode(FoodValuesCollection.self, from: data)
            return decodedResponse.meals
        }
        catch {
            throw FoodAppErrors.invalidData(error: error)
        }
    }
    /// The function is annotated with @MainActor, due to the parameter modelContext
    /// This method calls `fetchBriefMealValues()` to get the mealValues and inserts them to the `SwiftData` Food model
    /// - Parameters: modelContext, contains the SwiftData modelContext, used for insertion and saving the Database.
    @MainActor
    static func getBriefFoodInfo(modelContext: ModelContext) async {
        do {
            let mealValues = try await fetchBriefMealValues()
            
            for mealValue in mealValues {
                let food = Food(from: mealValue)
                modelContext.insert(food)
            }
            
            try modelContext.save()
            
        } catch {
            print("Error in getBreifFoodInfo()", error)
        }
    }
    
    /// uses `FoodDatabaseAPI` to get the URL and gets the JSON data from it
    ///  Decodes JSON data based on the `FoodValuesCollection` struct
    /// - Returns: `FoodInfo` instance, that consists of the meal value of the instance
    /// - Throws: Error if URL is invalid or if HTTP response is bad or if Unable to decode the data
    
    static func getEachMealValue(id: Int) async throws -> FoodInfo  {
        guard let baseURL = FoodDatabaseAPI.getMealWith(id: id).url else {
            throw FoodAppErrors.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FoodAppErrors.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(FoodValuesCollection.self, from: data)
            return decodedResponse.meals.first!
        }
        catch {
            throw FoodAppErrors.invalidFoodDetailedData(error: error)
        }
        
    }
    
    /// Due to an error with SwiftData, when new inserts are made, the old value is not upserted, instead duplicate values are formed. Even if unique atrribute constraint is provided. Hence this method is used as a temporary bug fix
    /// - Parameters:
    ///  - id: `Int` value, used to identify each meal in the API
    /// - Returns: A tuple with Instructions and Ingredients and Measures derived from the meal
    
    static func getFullInfo(of id: Int) async -> (String?, [String:String]) {
        do {
            let mealValue = try await getEachMealValue(id: id)
            return (mealValue.strInstructions, mealValue.strIngredientsAndMeasures)
        } catch {
            print(id, error)
        }
        return (nil, [:])
    }
    
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

