//
//  CDMigrationStep.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import CoreData



struct CDMigrationStep {
    
    let sourceModel: NSManagedObjectModel
    let destinationModel: NSManagedObjectModel
    let mappingModel: NSMappingModel
    
    init(source: CDMigrationVersion, destination: CDMigrationVersion) {
        let sourceModel = NSManagedObjectModel.load(from: source)
        let destinationModel = NSManagedObjectModel.load(from: destination)
        guard let mapping = CDMigrationStep.mappingModel(from: sourceModel, to: destinationModel)
        else { fatalError() }
        
        self.sourceModel = sourceModel
        self.destinationModel = destinationModel
        self.mappingModel = mapping
    }
    
}



// MARK: - Helper
extension CDMigrationStep {
    fileprivate static func mappingModel(
        from sourceModel: NSManagedObjectModel,
        to destinationModel: NSManagedObjectModel
    ) -> NSMappingModel? {
        if let customMapping = customMappingModel(from: sourceModel, to: destinationModel) {
            return customMapping
        } else if let inferredMapping = inferredMappingModel(from: sourceModel, to: destinationModel) {
            return inferredMapping
        } else {
            assertionFailure("Something's wrong...")
            return nil
        }
    }
    
    fileprivate static func inferredMappingModel(
        from sourceModel: NSManagedObjectModel,
        to destinationModel: NSManagedObjectModel
    ) -> NSMappingModel? {
        return try? NSMappingModel
            .inferredMappingModel(
                forSourceModel: sourceModel,
                destinationModel: destinationModel
            )
    }

    fileprivate static func customMappingModel(
        from sourceModel: NSManagedObjectModel,
        to destinationModel: NSManagedObjectModel
    ) -> NSMappingModel? {
        return NSMappingModel(
            from: [Bundle.main],
            forSourceModel: sourceModel,
            destinationModel: destinationModel
        )
    }
}

extension NSManagedObjectModel {
    static func load(from version: CDMigrationVersion) -> NSManagedObjectModel {
        let dirURL = Bundle.main.url(forResource: "PostsAndComments", withExtension: "momd")!
        let versionURL = dirURL.appendingPathComponent(String(format: "%@.mom", version.rawValue))
        
        guard let model = NSManagedObjectModel(contentsOf: versionURL)
        else { fatalError("Cannot init model.") }
        
        return model
    }
    
}
