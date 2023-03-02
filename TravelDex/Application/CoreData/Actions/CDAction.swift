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
