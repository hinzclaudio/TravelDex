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
                if let cdLoc = fetchLocation(by: loc.id, in: context) {
                    cdLoc.safeInitNeglectRelationShips(
                        id: Int64(loc.id),
                        latitude: loc.coordinate.latitude,
                        longitude: loc.coordinate.longitude,
                        name: loc.name,
                        region: loc.region,
                        country: loc.country,
                        queryParameter: loc.queryParameter
                    )
                } else if let cdLoc = fetchSimilarLocation(to: loc, in: context) {
                    return
                } else {
                    let cdLoc = CDLocation(context: context)
                    cdLoc.safeInit(
                        id: Int64(loc.id),
                        latitude: loc.coordinate.latitude,
                        longitude: loc.coordinate.longitude,
                        name: loc.name,
                        region: loc.region,
                        country: loc.country,
                        queryParameter: loc.queryParameter,
                        visitedPlaces: .init(),
                        weather: nil
                    )
                }
            }
    }
    
}
