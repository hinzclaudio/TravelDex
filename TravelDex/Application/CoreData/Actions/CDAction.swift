//
//  CDAction.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.08.22.
//

import Foundation
import CoreData



protocol CDAction {
    func execute(in context: NSManagedObjectContext) throws
}



extension CDAction {
    
    // MARK: - Trips
    func fetchTrip(by id: UUID, in context: NSManagedObjectContext) throws -> CDTrip? {
        let query = CDTrip.fetchRequest()
        query.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        query.fetchLimit = 1
        let fetched = try context.fetch(query)
        return fetched.first
    }
    
    func checkUnique(trip id: TripID, in context: NSManagedObjectContext) throws -> Bool {
        try fetchTrip(by: id, in: context) == nil
    }
    
    
    
    // MARK: - Locations
    func fetchSimilarLocation(coordinate: Coordinate, in context: NSManagedObjectContext) throws -> CDLocation? {
        let query = CDLocation.fetchRequest()
        query.predicate = NSPredicate(
            format: "abs(latitude - %f) < 0.0005 AND abs(longitude - %f) < 0.0005",
            coordinate.latitude, coordinate.longitude
        )
        query.fetchLimit = 1
        let fetched = try context.fetch(query)
        return fetched.first
    }
    
    func fetchLocation(by id: UUID, in context: NSManagedObjectContext) throws -> CDLocation? {
        let query = CDLocation.fetchRequest()
        query.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        query.fetchLimit = 1
        let fetched = try context.fetch(query)
        return fetched.first
    }
    
    func fetchUnusedLocations(in context: NSManagedObjectContext) throws -> [CDLocation] {
        let query = CDLocation.fetchRequest()
        query.predicate = NSPredicate(format: "visitedPlaces.@count == %d", 0)
        let locs = try context.fetch(query)
        return locs
    }
    
    
    
    // MARK: - Places
    func fetchVisitedPlace(by id: UUID, in context: NSManagedObjectContext) throws -> CDVisitedPlace? {
        let query = CDVisitedPlace.fetchRequest()
        query.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        query.fetchLimit = 1
        let fetched = try context.fetch(query)
        return fetched.first
    }
    
    func checkUnique(place id: VisitedPlaceID, in context: NSManagedObjectContext) throws -> Bool {
        try fetchVisitedPlace(by: id, in: context) == nil
    }
    
}
