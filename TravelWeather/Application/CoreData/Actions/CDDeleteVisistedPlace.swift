//
//  CDDeleteVisistedPlace.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 11.08.22.
//

import Foundation
import CoreData



struct CDDeleteVisitedPlace: CDAction {
    
    let visitedPlaceId: UUID
    
    func execute(in context: NSManagedObjectContext) {
        guard let cdPlace = fetchVisitedPlace(by: visitedPlaceId, in: context)
        else {
            assertionFailure("Something's missing...")
            return
        }
        
        context.delete(cdPlace)
        
        fetchUnusedLocations(in: context)
            .forEach(context.delete(_:))
    }
    
}
