//
//  DefaultCDStack.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import CoreData



final class DefaultCDStack: CDStackType {
    
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")
        else { fatalError("Unable to Find Data Model") }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else { fatalError("Unable to Load Data Model") }
        
        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            let fm = FileManager.default
            let dirURL = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            try fm.ensureDirectoryExists(at: dirURL)
            
            let storeName = modelName.appending(".sqlite")
            let storeURL = dirURL.appendingPathComponent(storeName)
            
            let migrator = CDMigrator()
            if migrator.requiresMigration(at: storeURL, to: .current) {
                migrator.migrateStore(at: storeURL, toVersion: .current)
            }
            
            let _ = try coordinator.addPersistentStore(type: .sqlite, at: storeURL)
        } catch {
            fatalError("Unable to add persistent store: \(error)")
        }
        
        return coordinator
    }()
    
    
    
    // MARK: - Contexts
    private(set) lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    private(set) lazy var storeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = saveContext
        return context
    }()
    
    private(set) lazy var reducerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = storeContext
        return context
    }()
    
    
    
    // MARK: Saving / Merging
    private func saveReducerContext(completion: @escaping (Error?) -> Void) {
        reducerContext.perform {
            guard self.reducerContext.hasChanges else {
                completion(nil)
                return
            }
            do {
                try self.reducerContext.save()
                print("CDStack: MERGED REDUCERCONTEXT")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    private func saveStoreContext(completion: @escaping (Error?) -> Void) {
        storeContext.perform {
            guard self.storeContext.hasChanges else {
                completion(nil)
                return
            }
            do {
                try self.storeContext.save()
                print("CDStack: MERGED STORECONTEXT")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    private func savePersistentStore(completion: @escaping (Error?) -> Void) {
         saveContext.perform {
            guard self.saveContext.hasChanges else {
                completion(nil)
                return
            }
            do {
                try self.saveContext.save()
                print("CDStack: Saved TO SQLITE")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    func save() {
        saveReducerContext { error in
            guard error == nil else {
                assertionFailure("Something's wrong: \(error!)")
                return
            }
            self.saveStoreContext { error in
                guard error == nil else {
                    assertionFailure("Something's wrong: \(error!)")
                    return
                }
                self.savePersistentStore { error in
                    guard error == nil else {
                        assertionFailure("Something's wrong: \(error!)")
                        return
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Actions
    func dispatch(_ action: CDAction) {
        reducerContext.perform {
            do {
                try action.execute(in: self.reducerContext)
                self.save()
            } catch {
                self.handle(error)
            }
        }
    }
    
    
    func handle(_ error: Error) {
        assertionFailure("Someting's wrong: \(error)")
    }
    
}
