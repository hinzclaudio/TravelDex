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
    
    
    func execute(in context: NSManagedObjectContext) {
        locations
            .forEach { loc in
                if let cdLoc = fetchLocation(by: loc.id, in: context) ??
                               fetchSimilarLocation(to: loc, in: context) {
                    cdLoc.safeInitNeglectRelationShips(
                        id: loc.id,
                        latitude: loc.coordinate.latitude,
                        longitude: loc.coordinate.longitude,
                        name: loc.name,
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
                        name: loc.name,
                        region: loc.region,
                        country: loc.country,
                        timezoneIdentifier: loc.timezoneIdentifier,
                        visitedPlaces: .init()
                    )
                }
            }
    }
    
}
