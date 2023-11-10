//
//  EachMealView.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import SwiftUI


struct FoodDetailedView: View {
    var meal: Food
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        VStack {
            HStack {
                Text(meal.name ?? "")
                    .font(.headline)
                    .fontWeight(.bold)
                
            }
            List {
                HStack {
                    Spacer()
                    AsyncImage(
                        url: meal.thumbnail) {  phase in
                            switch(phase) {
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 200, maxHeight: 200)
                            case .failure(_):
                                Color.clear
                                    .frame(maxWidth: 200, maxHeight: 200)
                            default :
                                ProgressView()
                                    .frame(maxWidth: 200, maxHeight: 200)
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

