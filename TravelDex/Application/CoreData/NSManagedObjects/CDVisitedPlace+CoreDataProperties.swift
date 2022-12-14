//
//  CDVisitedPlace+CoreDataProperties.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//
//

import Foundation
import CoreData


extension CDVisitedPlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDVisitedPlace> {
        return NSFetchRequest<CDVisitedPlace>(entityName: "CDVisitedPlace")
    }

    @NSManaged public var id: UUID
    @NSManaged public var text: String?
    @NSManaged public var pictureData: Data?
    @NSManaged public var start: Date
    @NSManaged public var end: Date
    // sourcery: relationship
    @NSManaged public var location: CDLocation
    // sourcery: relationship
    @NSManaged public var trip: CDTrip

}

extension CDVisitedPlace : Identifiable {

}
