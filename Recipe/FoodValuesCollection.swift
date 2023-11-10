//
//  FoodValuesCollection.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//
import Foundation
import SwiftData

struct FoodValuesCollection: Codable {
    
    let meals: [FoodInfo]
    
    struct FoodInfo: Codable {
        let id : Int
        let strMeal : String?
        let strInstructions: String?
        let strMealThumb: URL?
        var strIngredientsAndMeasures : [String : String]
        
        private enum CodingKeys: String, CodingKey {
            case id = "idMeal"
            case strMeal
            case strInstructions
            case strMealThumb
        }
        
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
        
        init(from decoder: Decoder) throws {
            do {
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



extension FoodValuesCollection.FoodInfo : Identifiable {}

extension FoodValuesCollection {
    static func fetchBriefMealValues() async throws -> [FoodInfo] {
        guard let baseURL = FoodDatabaseAPI.getMealsFrom(category: "Dessert").url else {
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
    
    static func getFullInfo(of id: Int) async -> (String?, [String:String]) {
        do {
            let mealValue = try await getEachMealValue(id: id)
            return (mealValue.strInstructions, mealValue.strIngredientsAndMeasures)
        } catch {
            print(id, error)
        }
        return (nil, [:])
    }
    
    static func getIntValueFromStringSuffix(stringValue: String) -> Int? {
        if let intValue = Int(stringValue.suffix(2)) {
            return intValue
        } else if let intValue = Int(stringValue.suffix(1)) {
            return intValue
        }
        return nil
    }
}

