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
            id: Int(id),
            name: name,
            region: region,
            country: country,
            coordinate: Coordinate(
                latitude: latitude,
                longitude: longitude
            ),
            queryParameter: queryParameter
        )
    }
    
}
