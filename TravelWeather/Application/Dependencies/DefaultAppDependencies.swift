//
//  DefaultAppDependencies.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



class DefaultAppDependencies: AppDependencies {
    
    let cdStack: CDStackType
    let tripsStore: TripsStoreType
    
    init() {
        let cdStack = DefaultCDStack(modelName: "TravelWeather")
        self.cdStack = cdStack
        self.tripsStore = TripsStore(context: cdStack.storeContext, dispatch: cdStack.dispatch(_:))
    }
    
}
