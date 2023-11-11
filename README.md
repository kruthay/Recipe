# Recipe
This a Take home assignment Repo

The app is developed using SwiftUI, and SwiftData.

It works on iOS 17 and later.




This App uses Food Recipe API from https://themealdb.com/api.php and utilised two specific endpoints


Main focus is on the Network API, Decoding JSON, Architecture. 




## Network

FoodDatabaseAPI.swift is used for organising the endpoints in a cleaner way. 
In case if url changes, only one point of change is necessary


## Decoding JSON

The JSON data from the API is challenging to use. It has 20 separate values for ingredients and 20 separate values for measures. 
Utilised DynamicCodingKeys with Codable to make it as cleaner as possible


## Architecture
I followed Model View architecture, started with MVVM, but when included SwiftData for caching purposes, MV made more sense than MVVM.
Caching wasn't a requirement but this felt like one chance to play with SwiftData, as it's not ready for production any time soon.


## UI

I haven't focused much on the UI as it wasn't required for the evaluation. 

Screenshots of the App:

<img src="/Screenshots/desserts.png" alt="Desserts" width="200"/> <img src="/Screenshots/info.png" alt="Information" width="200"/>

