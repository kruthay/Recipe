//
//  EachMealView.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import SwiftUI

/// Presents a detailed food view, with, name, thumnail, instructions and igredient details
/// ![FoodDetailedView screen shot 1](detailedView1Screenshot)
///
struct FoodDetailedView: View {
    /// `meal` is the `Food` instance, from which information is saved. This instance is binded to the SwiftData model
    var meal: Food
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(meal.name ?? "")
                    .font(.headline)
                    .fontWeight(.bold)
                
                List {
                    HStack {
                        Spacer()
                        AsyncImage(
                            url: meal.thumbnail) {  phase in
                                switch(phase) {
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: geometry.size.width/2, maxHeight: geometry.size.height/2)
                                case .failure(_):
                                    
                                    Color.clear
                                        .frame(maxWidth: geometry.size.width/2, maxHeight: geometry.size.height/2)
                                default :
                                    ProgressView()
                                        .frame(maxWidth: geometry.size.width/2, maxHeight: geometry.size.height/2)
                                }
                            }
                        Spacer()
                    }
                    
                    Section {
                        if let instructions  = meal.instructions {
                            Text(instructions)
                        } else {
                            ProgressView()
                        }
                        
                    } header: {
                        Text("Instructions")
                    }
                    Section {
                        ScrollView {
                            if meal.ingredientsAndMeasurements.isEmpty {
                                ProgressView()
                            }
                            else {
                                ForEach(meal.ingredientsAndMeasurements.sorted(by: >), id: \.key) { key, value in
                                    HStack {
                                        Text(key)
                                        Spacer()
                                        Text(value)
                                    }
                                    .padding()
                                }
                            }
                        }
                    } header: {
                        Text("Ingredients")
                    }
                    
                }
                .padding()
                .task {
                    if meal.instructions == nil && meal.ingredientsAndMeasurements.isEmpty {
                        let values = await FoodValuesCollection.getFullInfo(of: meal.id)
                        withAnimation {
                            (meal.instructions, meal.ingredientsAndMeasurements) = values
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FoodDetailedView(meal: Food.init(id: 123, name: "Sample Preview", thumbnail: URL(string:"https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"), instructions: """
Just for the Preview purposes.
Instructions are for the sample.
""", ingredientsAndMeasurements: ["Milk":"100ML", "Powder":"10Oz"]))
    .modelContainer(for: Food.self, inMemory: true)
}
