//
//  ContentView.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import SwiftUI
import SwiftData

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
            .listStyle(GroupedListStyle())
            .navigationTitle("Deserts")
            
            
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
