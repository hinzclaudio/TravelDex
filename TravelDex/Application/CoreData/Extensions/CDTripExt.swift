//
//  CDTripExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import CoreData



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
    
    func exportFormat(using context: NSManagedObjectContext) throws -> TripExport {
        let placesQuery = CDVisitedPlace.fetchRequest()
        placesQuery.predicate = NSPredicate(format: "trip.id == %@", id as CVarArg)
        placesQuery.sortDescriptors = [
            NSSortDescriptor(key: "start", ascending: true),
            NSSortDescriptor(key: "location.name", ascending: true)
        ]
        
        let places = try context.fetch(placesQuery)
        return TripExport(
            id: id,
            title: title,
            descr: descr,
            members: members,
            places: places
                .map { cdPlace -> VisitedPlaceExport in
                    VisitedPlaceExport(
                        id: cdPlace.id,
                        text: cdPlace.text,
                        start: cdPlace.start,
                        end: cdPlace.end,
                        locationName: cdPlace.location.name,
                        locationRegion: cdPlace.location.region,
                        locationCountry: cdPlace.location.country,
                        locationTimezone: cdPlace.location.timezoneIdentifier,
                        locationLatitude: cdPlace.location.latitude,
                        locationLongitude: cdPlace.location.longitude
                    )
                }
        )
    }
    
}



// MARK: - Ext Array
extension Array where Element == CDTrip {
    var sortedByPlaces: Array<CDTrip> {
        sorted { cdTrip0, cdTrip1 in
            let start0 = cdTrip0.startDate
            let start1 = cdTrip1.startDate
            if let start0 = start0, let start1 = start1 {
                return start0 < start1
            } else if start0 != nil {
                return true
            } else if start1 != nil {
                return false
            } else {
                return cdTrip0.title.localizedStandardCompare(cdTrip1.title) == .orderedAscending
            }
        }
    }
    
}
