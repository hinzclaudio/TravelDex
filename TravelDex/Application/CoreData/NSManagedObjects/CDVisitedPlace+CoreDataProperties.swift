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
    
    @NSManaged public var end: Date
    @NSManaged public var id: UUID
    @NSManaged public var start: Date
    @NSManaged public var text: String?
    @NSManaged public var region: String?
    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var country: String?
    // sourcery: relationship
    @NSManaged public var trip: CDTrip?
    // sourcery: relationship
    @NSManaged public var image: CDImageAttachment?

}

extension CDVisitedPlace : Identifiable {

}
