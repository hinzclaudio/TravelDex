//
//  CDLocationExt.swift
//  TravelDex
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
            coordinate: Coordinate(
                latitude: latitude,
                longitude: longitude
            ),
            timezoneIdentifier: timezoneIdentifier
        )
    }
    
}
