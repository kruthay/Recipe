# Recipe App

The app is developed using SwiftUI and SwiftData, compatible with iOS 17 and later.

It utilizes the Food Recipe API from [TheMealDB](https://themealdb.com/api.php) and focuses on two specific endpoints.

## Network

The `FoodDatabaseAPI.swift` organizes the endpoints for a cleaner structure. In case the URL changes, only one point of modification is necessary.

## Decoding JSON

Handling JSON data from the API can be challenging, especially with 20 separate values for ingredients and measures. 
DynamicCodingKeys with Codable is used to make the decoding process cleaner. I used two different struct models for bridging the JSON encoded data and SwiftData Model. 

## Architecture

The app follows a Model-View architecture. Initially, MVVM was considered, but with the inclusion of SwiftData for caching, MV architecture made more sense. 

## UI


Possible future changes:
1. Adding Tests
2. Improving the model to include additional API endpoints
3. Improving UI


Note: If some part of my code feels work around, I used those for the known bugs such as AsyncImage() returns Error when multiple images are rendered at the same time, so used LazyHStack even though it's not required, SwiftData has many such simple bugs. 




<img src="/Screenshots/desserts.png" alt="Desserts" width="200"/> <img src="/Screenshots/info.png" alt="Information" width="200"/>

