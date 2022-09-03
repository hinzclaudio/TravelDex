//
//  DefaultAppDependencies.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import CoreLocation



class DefaultAppDependencies: AppDependencies {
    
    let cdStack: CDStackType
    let geoCoder: CLGeocoder
    
    let tripsStore: TripsStoreType
    let placesStore: PlacesStoreType
    let locationsStore: LocationsStoreType
    
    init() {
        let cdStack = DefaultCDStack(modelName: "TravelDex")
        let geoCoder = CLGeocoder()
        
        self.cdStack = cdStack
        self.geoCoder = geoCoder
        
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
            locationAPI: geoCoder
        )
    }
    
}
