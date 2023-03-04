//
//  DefaultCDStack.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import CoreData
import CloudKit



final class DefaultCDStack: CDStackType {

    public let modelName: String
    public let containerIdentifier: String
    
    init(modelName: String, containerIdentifier: String) {
        self.modelName = modelName
        self.containerIdentifier = containerIdentifier
    }
    

    private(set) lazy var persistentContainer: NSPersistentCloudKitContainer = {
        var privateStoreURL: URL!
        var sharedStoreURL: URL!
        
        /*
         Perform any migrations that need to happen...
         */
        do {
            let fm = FileManager.default
            let dirURL = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            try fm.ensureDirectoryExists(at: dirURL)
            
            let privateStoreName = modelName.appending(".sqlite")
            privateStoreURL = dirURL.appendingPathComponent(privateStoreName)
            
            let sharedStoreName = modelName.appending(".shared.sqlite")
            sharedStoreURL = dirURL.appendingPathComponent(sharedStoreName)
            
            let migrator = CDMigrator()
            if migrator.requiresMigration(at: privateStoreURL, to: .current) {
                migrator.migrateStore(at: privateStoreURL, toVersion: .current)
            }
            if migrator.requiresMigration(at: sharedStoreURL, to: .current) {
                migrator.migrateStore(at: sharedStoreURL, toVersion: .current)
            }
        } catch {
            fatalError("CDStack: \(error)")
        }
        
        /*
         Now we actually create the container and configure it with two
         store descriptions:
         - A private store for data where the user is the owner of the data
         - A shared store for data that is shared with this user.
         */
        let container = NSPersistentCloudKitContainer(name: modelName)
        guard let privateStoreDescription = container.persistentStoreDescriptions.first else {
            fatalError("Something's missing...")
        }
        privateStoreDescription.url = privateStoreURL
        privateStoreDescription.setOption(
            true as NSNumber, forKey: NSPersistentHistoryTrackingKey
        )
        privateStoreDescription.setOption(
            true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )

        let cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        cloudKitContainerOptions.databaseScope = .private
        privateStoreDescription.cloudKitContainerOptions = cloudKitContainerOptions

        guard let sharedStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
            fatalError("Something's missing....")
        }
        sharedStoreDescription.url = sharedStoreURL
        let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        sharedStoreOptions.databaseScope = .shared
        sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
        container.persistentStoreDescriptions.append(sharedStoreDescription)
        
        container.loadPersistentStores { storeDescr, error in
            if let error = error {
                fatalError("CDStack: \(error)")
            }
            guard let cloudKitContainerOptions = storeDescr.cloudKitContainerOptions else { return }
            if cloudKitContainerOptions.databaseScope == .private {
                self._privateStore = container.persistentStoreCoordinator
                    .persistentStore(for: storeDescr.url!)
            } else if cloudKitContainerOptions.databaseScope  == .shared {
                self._sharedStore = container.persistentStoreCoordinator
                    .persistentStore(for: storeDescr.url!)
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    private var _privateStore: NSPersistentStore?
    public var privateStore: NSPersistentStore {
        _privateStore!
    }
    
    private var _sharedStore: NSPersistentStore?
    public var sharedStore: NSPersistentStore {
        _sharedStore!
    }
    
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
                print("CDStack: SAVED TO PERSISTENT STORE")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func save() {
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
    public func dispatch(_ action: CDAction) {
        reducerContext.perform {
            do {
                try action.execute(in: self.reducerContext)
                self.save()
            } catch {
                self.handle(error)
            }
        }
    }
    
    private func handle(_ error: Error) {
        assertionFailure("Someting's wrong: \(error)")
    }
    
}
