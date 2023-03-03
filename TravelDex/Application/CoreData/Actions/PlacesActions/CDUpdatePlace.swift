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
                start: place.start,
                text: place.text,
                region: place.location.region,
                name: place.location.name,
                latitude: place.location.coordinate.latitude,
                longitude: place.location.coordinate.longitude,
                country: place.location.country
            )
            if let image = place.picture {
                let attachment = CDImageAttachment(context: context)
                attachment.safeInit(imageData: image, visitedPlace: cdPlace)
            } else if let attachment = cdPlace.image {
                context.delete(attachment)
            }
            
        } else if let tripId = place.tripId,
                  let cdTrip = try fetchTrip(by: tripId, in: context) {
            let cdPlace = CDVisitedPlace(context: context)
            cdPlace.safeInitNeglectRelationShips(
                end: end,
                id: place.id,
                start: place.start,
                text: place.text,
                region: place.location.region,
                name: place.location.name,
                latitude: place.location.coordinate.latitude,
                longitude: place.location.coordinate.longitude,
                country: place.location.country
            )
            cdPlace.trip = cdTrip
            if let image = place.picture {
                let attachment = CDImageAttachment(context: context)
                attachment.safeInit(imageData: image, visitedPlace: cdPlace)
            }
            
        } else {
            assertionFailure("Something's missing...")
        }
    }
    
}
