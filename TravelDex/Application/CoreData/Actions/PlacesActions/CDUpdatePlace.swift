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
            cdPlace.trip?.dummyBit.toggle()
            cdPlace.safeInitNeglectRelationShips(
                end: end,
                id: place.id,
                pictureData: place.picture,
                start: place.start,
                text: place.text,
                region: place.location.region,
                name: place.location.name,
                latitude: place.location.coordinate.latitude,
                longitude: place.location.coordinate.longitude,
                country: place.location.country
            )
        } else if let tripId = place.tripId,
                  let cdTrip = try fetchTrip(by: tripId, in: context) {
            let cdPlace = CDVisitedPlace(context: context)
            cdPlace.safeInit(
                end: end,
                id: place.id,
                pictureData: place.picture,
                start: place.start,
                text: place.text,
                region: place.location.region,
                name: place.location.name,
                latitude: place.location.coordinate.latitude,
                longitude: place.location.coordinate.longitude,
                country: place.location.country,
                trip: cdTrip
            )
        } else {
            assertionFailure("Something's missing...")
        }
    }
    
}
