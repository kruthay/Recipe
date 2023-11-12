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
//        .refreshable {
//            await MealsCollection.getBriefFoodInfo(modelContext: modelContext)
//        }
        .task {
            if foodValues.isEmpty {
                await FoodValuesCollection.getBriefFoodInfo(modelContext: modelContext)
            }
        }
        
    }

}

#Preview {
    HomeView()
        .modelContainer(for: Food.self, inMemory: true)
}
