//
//  CDImageAttachment+CoreDataProperties.swift
//  TravelDex
//
//  Created by Claudio Hinz on 03.03.23.
//
//

import Foundation
import CoreData


extension CDImageAttachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDImageAttachment> {
        return NSFetchRequest<CDImageAttachment>(entityName: "CDImageAttachment")
    }

    @NSManaged public var imageData: Data
    // sourcery: relationship
    @NSManaged public var visitedPlace: CDVisitedPlace?

}

extension CDImageAttachment : Identifiable {

}
