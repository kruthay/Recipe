//
//  ItemView.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/10/23.
//

import SwiftUI


struct ItemView: View {
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
            HStack {
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
    }
}


//#Preview {
//   ItemView()
//}