# Recipe App Take-Home Assignment

This is a take-home assignment repository.

Result: Not Selected.
UPDATE: 
Feedback: 
1. UI not compatible with all devices. Update: Made changes using GeometryReader
2. Not used generic network layer. Update: Changed the network layer to make it generic
3. Used naming convention from API. Update: Changed the naming for the Model to suit the app.
4. Unit Tests. Update: In Progress

The app is developed using SwiftUI and SwiftData, compatible with iOS 17 and later.

It utilizes the Food Recipe API from [TheMealDB](https://themealdb.com/api.php) and focuses on two specific endpoints.

## Network

The `FoodDatabaseAPI.swift` organizes the endpoints for a cleaner structure. In case the URL changes, only one point of modification is necessary.

## Decoding JSON

Handling JSON data from the API can be challenging, especially with 20 separate values for ingredients and measures. 
DynamicCodingKeys with Codable is used to make the decoding process cleaner. I used two different struct models for bridging the JSON encoded data and SwiftData Model. 

## Architecture

The app follows a Model-View architecture. Initially, MVVM was considered, but with the inclusion of SwiftData for caching, MV architecture made more sense. Caching wasn't a requirement, but it provided me an opportunity to experiment with SwiftData.

## UI

Not much focus was given to the UI as it wasn't required for evaluation. Screenshots of the app:

Assumptions:
1. I assumed caching was an important part of the application, as it reduces network connection for smoother User Experience.
2. I haven't focussed much on Testing, primarly because of the SwiftData inclusion and it required me to write a lot of boiler-plate code. 
Please let me know if you would like me to write some tests
3. More documentation about each method in the Model part of the application is available in the code. Please look into it.

Possible future changes:
1. Adding Tests
2. Improving the model to include additional API endpoints
3. Improving UI


Note: If some part of my code feels work around, I used those for the known bugs such as AsyncImage() returns Error when multiple images are rendered at the same time, so used LazyHStack even though it's not required, SwiftData has many such simple bugs. 




<img src="/Screenshots/desserts.png" alt="Desserts" width="200"/> <img src="/Screenshots/info.png" alt="Information" width="200"/>

