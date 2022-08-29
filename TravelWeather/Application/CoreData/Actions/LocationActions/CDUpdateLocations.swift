//
//  CDUpdateLocations.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation
import CoreData



struct CDUpdateLocations: CDAction {
    
    let locations: [Location]
    
    
    func execute(in context: NSManagedObjectContext) throws {
        try locations
            .forEach { loc in
                let name: String
                if loc.name.isEmpty {
                    name = "Unknown Location"
                } else {
                    name = loc.name
                }
                
                if let cdLoc = try fetchLocation(by: loc.id, in: context) {
                    cdLoc.safeInitNeglectRelationShips(
                        id: loc.id,
                        latitude: loc.coordinate.latitude,
                        longitude: loc.coordinate.longitude,
                        name: name,
                        region: loc.region,
                        country: loc.country,
                        timezoneIdentifier: loc.timezoneIdentifier
                    )
                } else {
                    let cdLoc = CDLocation(context: context)
                    cdLoc.safeInit(
                        id: loc.id,
                        latitude: loc.coordinate.latitude,
                        longitude: loc.coordinate.longitude,
                        name: name,
                        region: loc.region,
                        country: loc.country,
                        timezoneIdentifier: loc.timezoneIdentifier,
                        visitedPlaces: .init()
                    )
                }
            }
    }
    
}
