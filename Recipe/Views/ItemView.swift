//
//  ItemView.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import SwiftUI

/// `ItemView` consists of the name and Image of the meal
/// ```swift
///  let meal = Food(id: 123, name: "Sample Preview", thumbnail: URL(string:"https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"), instructions: """ Just for the Preview purposes. Instructions are for the sample. """, ingredientsAndMeasurements: ["Milk":"100ML", "Powder":"10Oz"])
///  ItemView(meal: meal)
///  ```
///  ![ItemView sample usage](itemViewScreenshot)
struct ItemView: View {
    /// `meal` is the `Food` instance, from which information is saved. This instance is binded to the SwiftData model
    var meal: Food
    var body: some View {
        HStack(alignment: .center) {
            if let mealName = meal.name {
                Text(mealName)
                    .lineLimit(1)
            } else {
                Text("Name Unavailable")
            }
            Spacer()
            // Used as a temporary bug fix to AsyncImage, AsyncImage when loads more than a few Images doesn't load all of them and cancels some
            LazyHStack {
                Spacer()
                AsyncImage(
                    url: meal.thumbnail) {  phase in
                        switch(phase) {
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 50, maxHeight: 50)
                        case .failure(_):
                            Color.clear
                                .frame(maxWidth: 50, maxHeight: 50)
                        default :
                            ProgressView()
                                .frame(maxWidth: 50, maxHeight: 50)
                        }
                    }
            }
            
        }
        .padding()
    }
}


#Preview {
   ItemView(meal: Food(id: 123, name: "Sample Preview", thumbnail: URL(string:"https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"), instructions: """
Just for the Preview purposes.
Instructions are for the sample.
""", ingredientsAndMeasurements: ["Milk":"100ML", "Powder":"10Oz"]))
    .modelContainer(for: Food.self, inMemory: true)
}
