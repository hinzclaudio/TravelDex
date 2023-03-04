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
    let skStore: SKStoreType
    let ckStore: CKStoreType
    
    init() {
        let cdStack = DefaultCDStack(modelName: "TravelDex", containerIdentifier: "iCloud.TravelDex.app")
        let geoCoder = CLGeocoder()
        
        self.cdStack = cdStack
        self.geoCoder = geoCoder
        
        self.tripsStore = TripsStore(
            context: cdStack.saveContext,
            dispatch: cdStack.dispatch(_:)
        )
        self.placesStore = PlacesStore(
            context: cdStack.saveContext,
            dispatch: cdStack.dispatch(_:)
        )
        self.locationsStore = LocationsStore(
            context: cdStack.saveContext,
            dispatch: cdStack.dispatch(_:),
            locationAPI: geoCoder
        )
        self.skStore = SKStore()
        self.ckStore = CKStore(cdStack: cdStack)
    }
    
}
