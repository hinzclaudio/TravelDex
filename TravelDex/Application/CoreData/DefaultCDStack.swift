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
    

    private lazy var persistentContainer: NSPersistentContainer = {
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
        } catch {
            fatalError("CDStack: \(error)")
        }
        
        // Actually initialize the store
        let container = NSPersistentCloudKitContainer(name: modelName)
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        } else {
            assertionFailure("Something's missing...")
        }
        
        container.loadPersistentStores { storeDescr, error in
            if let error = error {
                fatalError("CDStack: \(error)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    
    
    // MARK: - Contexts
    private(set) lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private(set) lazy var reducerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = saveContext
        context.automaticallyMergesChangesFromParent = true
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
    
    private func savePersistentStore(completion: @escaping (Error?) -> Void) {
         saveContext.perform {
            guard self.saveContext.hasChanges else {
                completion(nil)
                return
            }
            do {
                try self.saveContext.save()
                print("CDStack: SAVED TO SQLITE")
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
            self.savePersistentStore { error in
                guard error == nil else {
                    assertionFailure("Something's wrong: \(error!)")
                    return
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
