//
//  TripsStore.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import CoreData



class TripsStore: TripsStoreType {
    
    let context: NSManagedObjectContext
    let dispatch: (CDAction) -> Void
    
    init(context: NSManagedObjectContext, dispatch: @escaping (CDAction) -> Void) {
        self.context = context
        self.dispatch = dispatch
    }
    
    
}
