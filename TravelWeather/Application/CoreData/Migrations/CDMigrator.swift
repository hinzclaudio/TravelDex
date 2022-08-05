//
//  CDMigrator.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import CoreData



class CDMigrator {
    
    func requiresMigration(at storeURL: URL, to version: CDMigrationVersion) -> Bool {
        do {
            let metaData = try NSPersistentStoreCoordinator
                .metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL)
            return CDMigrationVersion.compatibleVersionForStore(metaData) != version
        } catch {
            let error = error as NSError
            if error.code == NSFileReadNoSuchFileError,
               error.domain == NSCocoaErrorDomain {
                return false
            } else {
                assertionFailure("Something's wrong: \(error)")
                return false
            }
        }
    }
    
    
    func migrateStore(at storeURL: URL, toVersion version: CDMigrationVersion) {
        do {
            let metaData = try NSPersistentStoreCoordinator
                .metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL)
            try forceWALCheckpointingForStore(at: storeURL, with: metaData)
            var currentURL = storeURL
            let migrationSteps = migrationStepsForStore(at: storeURL, with: metaData, toVersion: version)
            
            try migrationSteps
                .forEach { step in
                    let manager = NSMigrationManager(
                        sourceModel: step.sourceModel,
                        destinationModel: step.destinationModel
                    )
                    let destURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                        .appendingPathComponent(UUID().uuidString)
                    try manager.migrateStore(
                        from: currentURL, sourceType: NSSQLiteStoreType, options: nil, with: step.mappingModel,
                        toDestinationURL: destURL, destinationType: NSSQLiteStoreType, destinationOptions: nil
                    )
                    
                    if currentURL != storeURL {
                        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: .init())
                        try coordinator.destroyPersistentStore(at: currentURL, ofType: NSSQLiteStoreType)
                    }
                    
                    currentURL = destURL
                }
            
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: .init())
            try coordinator.replacePersistentStore(
                at: storeURL, withPersistentStoreFrom: currentURL, ofType: NSSQLiteStoreType
            )
            if currentURL != storeURL {
                try coordinator.destroyPersistentStore(at: currentURL, ofType: NSSQLiteStoreType)
            }
            
        } catch {
            assertionFailure("Something's wrong: \(error)")
        }
    }


    // MARK: - WAL + Helper
    private func forceWALCheckpointingForStore(at storeURL: URL, with metadata: [String:Any]) throws {
        guard let currentVersion = CDMigrationVersion.compatibleVersionForStore(metadata)
        else { return }
        let currentModel = NSManagedObjectModel.load(from: currentVersion)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: currentModel)

        let options = [NSSQLitePragmasOption: ["journal_mode": "DELETE"]]
        let store = try coordinator
            .addPersistentStore(type: .sqlite, at: storeURL, options: options)
        try coordinator
            .remove(store)
    }
    
    
    private func migrationStepsForStore(at storeURL: URL, with metadata: [String:Any],
                                        toVersion destination: CDMigrationVersion) -> [CDMigrationStep] {
        guard var sourceVersion = CDMigrationVersion.compatibleVersionForStore(metadata)
        else { return [] }
        var steps = [CDMigrationStep]()
        
        while sourceVersion != destination,
              let nextVersion = sourceVersion.nextVersion {
            let step = CDMigrationStep(source: sourceVersion, destination: nextVersion)
            steps.append(step)
            sourceVersion = nextVersion
        }
        
        return steps
    }
    
}


// MARK: - Helpers
private extension CDMigrationVersion {
    static func compatibleVersionForStore(_ metadata: [String:Any]) -> CDMigrationVersion? {
        CDMigrationVersion
            .allCases
            .first(where: { version in
                let model = NSManagedObjectModel.load(from: version)
                return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
            })
    }
    
}
