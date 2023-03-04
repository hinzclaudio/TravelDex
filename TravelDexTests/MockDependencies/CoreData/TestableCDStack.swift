//
//  TestableCDStack.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import CoreData
@testable import TravelDex



class TestableCDStack: CDStackType {
    
    let modelName = "TravelDex"
    
    var privateStore: NSPersistentStore {
        fatalError("Unavailable in test environment!")
    }
    
    var sharedStore: NSPersistentStore {
        fatalError("Unavailable in test environment!")
    }
    
    
    // MARK: - Model + Container
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")
        else { fatalError("Unable to Find Data Model") }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else { fatalError("Unable to Load Data Model") }
        
        return managedObjectModel
    }()
    
    
    public lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentCloudKitContainer(
            name: modelName,
            managedObjectModel: managedObjectModel
        )

        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    
    
    // MARK: - NSManaged Contexts
    private(set) lazy var saveContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    private(set) lazy var reducerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = saveContext
        return context
    }()
    
    
    
    // MARK: - Funcs
    func save() {
        reducerContext.perform {
            if self.reducerContext.hasChanges {
                do { try self.reducerContext.save() }
                catch { assertionFailure("Error: \(error)") }
            }
            
            self.saveContext.perform {
                if self.saveContext.hasChanges {
                    do { try self.saveContext.save() }
                    catch { assertionFailure("Error: \(error)") }
                }
            }
        }
    }
    
    func dispatch(_ action: CDAction) {
        reducerContext.perform {
            do {
                try action.execute(in: self.reducerContext)
                self.save()
            } catch {
                assertionFailure("Error: \(error)")
            }
        }
    }
    
}
