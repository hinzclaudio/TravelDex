//
//  DefaultAppDependencies.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



class DefaultAppDependencies: AppDependencies {
    
    let cdStack: CDStackType
    let weatherAPI: WeatherAPI
    
    let tripsStore: TripsStoreType
    let placesStore: PlacesStoreType
    let locationsStore: LocationsStoreType
    
    init() {
        let cdStack = DefaultCDStack(modelName: "TravelWeather")
        let weatherAPI = WeatherAPI()
        self.cdStack = cdStack
        self.weatherAPI = weatherAPI
        
        self.tripsStore = TripsStore(
            context: cdStack.storeContext,
            dispatch: cdStack.dispatch(_:)
        )
        self.placesStore = PlacesStore(
            context: cdStack.storeContext,
            dispatch: cdStack.dispatch(_:)
        )
        self.locationsStore = LocationsStore(
            context: cdStack.storeContext,
            dispatch: cdStack.dispatch(_:),
            api: weatherAPI
        )
    }
    
}
