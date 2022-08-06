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
            cdTrip.title = trip.title
            cdTrip.descr = trip.descr
            cdTrip.members = trip.members
        } else {
            let cdTrip = CDTrip(context: context)
            cdTrip.safeInit(
                id: trip.id,
                title: trip.title,
                descr: trip.descr,
                members: trip.members,
                pictureData: nil,
                visitedPlaces: .init()
            )
        }
    }
    
}
