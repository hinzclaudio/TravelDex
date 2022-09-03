//
//  CDUpdatePlace.swift
//  TravelDex
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation
import CoreData



struct CDUpdatePlace: CDAction {
    
    let place: VisitedPlace
    
    
    func execute(in context: NSManagedObjectContext) throws {
        let end: Date = (place.end < place.start) ? place.start : place.end
        if let cdPlace = try fetchVisitedPlace(by: place.id, in: context) {
            cdPlace.safeInitNeglectRelationShips(
                id: place.id,
                text: place.text,
                pictureData: place.picture,
                start: place.start,
                end: end
            )
        } else if let cdTrip = try fetchTrip(by: place.tripId, in: context),
                  let cdLoc = try fetchLocation(by: place.locationId, in: context) {
            let cdPlace = CDVisitedPlace(context: context)
            cdPlace.safeInit(
                id: place.id,
                text: place.text,
                pictureData: place.picture,
                start: place.start,
                end: end,
                location: cdLoc,
                trip: cdTrip
            )
        } else {
            assertionFailure("Something's missing...")
        }
    }
    
}
