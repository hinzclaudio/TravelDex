//
//  CDDeleteTrip.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import CoreData



struct CDDeleteTrip: CDAction {
    
    let trip: Trip
    
    
    func execute(in context: NSManagedObjectContext) throws {
        guard let cdTrip = fetchTrip(by: trip.id, in: context)
        else {
            assertionFailure("Something's missing...")
            return
        }
        
        context.delete(cdTrip)
        fetchUnusedLocations(in: context)
            .forEach(context.delete(_:))
    }
    
}
