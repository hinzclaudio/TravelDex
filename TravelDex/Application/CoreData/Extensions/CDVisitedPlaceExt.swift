//
//  CDVisitedPlace.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation



extension CDVisitedPlace {
    
    var pureRepresentation: VisitedPlace {
        VisitedPlace(
            id: id,
            text: text,
            picture: image?.imageData,
            start: start,
            end: end,
            tripId: trip?.id,
            location: Location(
                name: name,
                region: region,
                country: country,
                coordinate: Coordinate(
                    latitude: latitude,
                    longitude: longitude
                )
            )
        )
    }
    
}
