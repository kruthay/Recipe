//
//  ContentView.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import SwiftUI
import SwiftData

/// HomeView consists of the list of meals present in the model of the `Desserts` Category
/// if the `Array<Food>` is empty, then Information is retrieved from the internet and saved to the local database
/// ![Home View of the with Food App Screenshot ](listViewScreenshot)
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Food.name, animation: .bouncy) private var foodValues: [Food]
    var body: some View {
        NavigationStack {
            List(foodValues) { food in
                NavigationLink(destination: FoodDetailedView(meal: food)) {
                    ItemView(meal: food)
                }
            }

            .navigationTitle("Desserts")
            
            
        }

        .task {
            if foodValues.isEmpty {
                await getBriefFoodInfo(category: "Dessert")
            }
        }
        
    }
}

extension HomeView {
    func getBriefFoodInfo(category: String) async {
        do {
            let service: FoodService = FoodService()
            let foodResponse = try await service.getMealsFrom(category: category)
            let mealValues = foodResponse.meals
            for mealValue in mealValues {
                let food = Food(from: mealValue)
                modelContext.insert(food)
            }
            
            try modelContext.save()
            
        } catch {
            print("Error in getBreifFoodInfo()", error)
        }
    }
    
}

#Preview {
    HomeView()
        .modelContainer(for: Food.self, inMemory: true)
}
