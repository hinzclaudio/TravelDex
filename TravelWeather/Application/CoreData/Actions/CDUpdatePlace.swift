//
//  CDUpdatePlace.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation
import CoreData



struct CDUpdatePlace: CDAction {
    
    let place: VisitedPlace
    
    
    func execute(in context: NSManagedObjectContext) {
        let end: Date = (place.end < place.start) ? place.start : place.end
        if let cdPlace = fetchVisitedPlace(by: place.id, in: context) {
            cdPlace.safeInitNeglectRelationShips(
                id: place.id,
                text: place.text,
                pictureData: place.picture,
                start: place.start,
                end: end
            )
        } else if let cdTrip = fetchTrip(by: place.tripId, in: context),
                  let cdLoc = fetchLocation(by: place.locationId, in: context) {
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
