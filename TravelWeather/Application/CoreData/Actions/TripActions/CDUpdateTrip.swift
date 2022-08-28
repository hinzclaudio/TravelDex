//
//  CDUpdateTrip.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import CoreData



struct CDUpdateTrip: CDAction {
    
    let trip: Trip
    
    
    func execute(in context: NSManagedObjectContext) {
        if let cdTrip = fetchTrip(by: trip.id, in: context) {
            cdTrip.safeInitNeglectRelationShips(
                descr: trip.descr,
                id: trip.id,
                members: trip.members,
                pictureData: nil,
                title: trip.title,
                pinColorRed: Int16(trip.pinColorRed),
                pinColorGreen: Int16(trip.pinColorGreen),
                pinColorBlue: Int16(trip.pinColorBlue)
            )
        } else {
            let cdTrip = CDTrip(context: context)
            cdTrip.safeInit(
                descr: trip.descr,
                id: trip.id,
                members: trip.members,
                pictureData: nil,
                title: trip.title,
                pinColorRed: Int16(trip.pinColorRed),
                pinColorGreen: Int16(trip.pinColorGreen),
                pinColorBlue: Int16(trip.pinColorBlue),
                visitedPlaces: .init()
            )
        }
    }
    
}
