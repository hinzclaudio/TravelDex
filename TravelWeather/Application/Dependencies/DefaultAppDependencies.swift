//
//  DefaultAppDependencies.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



class DefaultAppDependencies: AppDependencies {
    
    let tripsStore: TripsStoreType
    
    init() {
        self.tripsStore = TripsStore()
    }
    
}
