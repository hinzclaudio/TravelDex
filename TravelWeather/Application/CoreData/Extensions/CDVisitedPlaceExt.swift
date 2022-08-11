//
//  CDVisitedPlace.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation



extension CDVisitedPlace {
    
    var pureRepresentation: VisitedPlace {
        VisitedPlace(
            id: id,
            text: text,
            picture: pictureData,
            start: start,
            end: end,
            tripId: trip.id,
            locationId: Int(location.id)
        )
    }
    
}
