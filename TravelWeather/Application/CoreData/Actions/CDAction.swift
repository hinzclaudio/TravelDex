//
//  CDAction.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 04.08.22.
//

import Foundation
import CoreData



protocol CDAction {
    func execute(in context: NSManagedObjectContext)
}



extension CDAction {
    
    func fetchTrip(by id: UUID, in context: NSManagedObjectContext) -> CDTrip? {
        let query = CDTrip.fetchRequest()
        query.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        query.fetchLimit = 1
        do {
            let fetched = try context.fetch(query)
            return fetched.first
        } catch {
            handleCD(error)
            return nil
        }
    }
    
    
    func fetchLocation(by id: Int, in context: NSManagedObjectContext) -> CDLocation? {
        let query = CDLocation.fetchRequest()
        query.predicate = NSPredicate(format: "id == %d", id)
        query.fetchLimit = 1
        do {
            let fetched = try context.fetch(query)
            return fetched.first
        } catch {
            handleCD(error)
            return nil
        }
    }
    
    
    func handleCD(_ error: Error) {
        assertionFailure("Something's wrong: \(error)")
    }
    
}
