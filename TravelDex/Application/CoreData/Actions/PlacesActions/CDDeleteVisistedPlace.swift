//
//  CDDeleteVisistedPlace.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.08.22.
//

import Foundation
import CoreData



struct CDDeleteVisitedPlace: CDAction {
    
    let visitedPlaceId: UUID
    
    func execute(in context: NSManagedObjectContext) throws {
        guard let cdPlace = try fetchVisitedPlace(by: visitedPlaceId, in: context)
        else {
            assertionFailure("Something's missing...")
            return
        }
        
        context.delete(cdPlace)
        
        try fetchUnusedLocations(in: context)
            .forEach(context.delete(_:))
    }
    
}
