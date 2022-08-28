//
//  CDTripExt.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation



extension CDTrip {
    
    var pureRepresentation: Trip {
        Trip(
            id: id,
            title: title,
            descr: descr,
            members: members,
            visitedLocations: visitedPlaces
                .asArray(of: CDVisitedPlace.self)!
                .map { $0.id },
            start: startDate,
            end: endDate,
            pinColorRed: UInt8(pinColorRed),
            pinColorGreen: UInt8(pinColorGreen),
            pinColorBlue: UInt8(pinColorBlue)
        )
    }
    
    
    var startDate: Date? {
        visitedPlaces
            .asArray(of: CDVisitedPlace.self)!
            .map { $0.start }
            .min()
    }
    
    var endDate: Date? {
        visitedPlaces
            .asArray(of: CDVisitedPlace.self)!
            .map { $0.end }
            .min()
    }
    
}
