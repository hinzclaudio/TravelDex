//
//  CDStack.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 04.08.22.
//

import Foundation
import CoreData



protocol CDStackType {
    var mainContext: NSManagedObjectContext { get }
    var privateQueueContext: NSManagedObjectContext { get }
    var reducerContext: NSManagedObjectContext { get }
}



class CDStack: CDStackType {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TravelWeather")
        container.loadPersistentStores { (storeDescription, error) in
            guard let error = error else { return }
            fatalError("CDError: \(error)")
        }
        return container
    }()
    
    
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private(set) lazy var privateQueueContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = false
        return context
    }()
    
    private(set) lazy var reducerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = privateQueueContext
        context.automaticallyMergesChangesFromParent = false
        return context
    }()
    
    
    
    
    
}
