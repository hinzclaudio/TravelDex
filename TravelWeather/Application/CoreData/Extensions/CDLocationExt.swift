//
//  CDLocationExt.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation



extension CDLocation {
    
    var pureRepresentation: Location {
        Location(
            id: id,
            name: name,
            region: region,
            country: country,
            timezone: timezone,
            coordinate: Coordinate(
                latitude: latitude,
                longitude: longitude
            )
        )
    }
    
}
