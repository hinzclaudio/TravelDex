//
//  CDImageAttachmentCreationPolicy.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.03.23.
//

import Foundation
import CoreData
import UIKit



class CDImageAttachmentCreationPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        // We only create dInstances when an image is available...
        guard let orgData = sInstance.primitiveValue(forKey: "pictureData") as? Data,
              let orgImage = UIImage(data: orgData)
        else { return }
        
        var resizedData: Data = orgData
        if let data = orgImage.jpegData(compressionQuality: ImageConstants.defaultJPEGCompression) {
            resizedData = data
        }
        
        let description = NSEntityDescription.entity(forEntityName: "CDImageAttachment", in: manager.destinationContext)!
        let attachmentEntity = CDImageAttachment(entity: description, insertInto: manager.destinationContext)
        attachmentEntity.setValue(resizedData, forKey: "imageData")
        manager.associate(sourceInstance: sInstance, withDestinationInstance: attachmentEntity, for: mapping)
        
        let percentSaved = 1 - Double(resizedData.count) / Double(orgData.count)
        print("MIGRATION: Saved \(percentSaved) %")
    }
    
    override func createRelationships(forDestination dInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        guard let placeInSourceContext = manager
            .sourceInstances(forEntityMappingName: mapping.name, destinationInstances: [dInstance])
            .first,
              let placeId = placeInSourceContext.primitiveValue(forKey: "id") as? UUID
        else {
            assertionFailure("Something's missing...")
            return
        }
        
        let placesQuery = NSFetchRequest<NSManagedObject>(entityName: "CDVisitedPlace")
        placesQuery.predicate = NSPredicate(format: "id = %@", placeId as CVarArg)
        let fetchedPlaces = try manager.destinationContext.fetch(placesQuery)
        guard let placeInDestinationContext = fetchedPlaces.first else  {
            assertionFailure("Something's missing...")
            return
        }
        
        dInstance.setValue(placeInDestinationContext, forKey: "visitedPlace")
    }
    
}
