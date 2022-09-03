//
//  CDTrip+CoreDataProperties.swift
//  TravelDex
//
//  Created by Claudio Hinz on 28.08.22.
//
//

import Foundation
import CoreData


extension CDTrip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTrip> {
        return NSFetchRequest<CDTrip>(entityName: "CDTrip")
    }

    @NSManaged public var descr: String?
    @NSManaged public var id: UUID
    @NSManaged public var members: String?
    @NSManaged public var pictureData: Data?
    @NSManaged public var title: String
    @NSManaged public var pinColorRed: Int16
    @NSManaged public var pinColorGreen: Int16
    @NSManaged public var pinColorBlue: Int16
    // sourcery: relationship
    @NSManaged public var visitedPlaces: NSSet

}

// MARK: Generated accessors for visitedPlaces
extension CDTrip {

    @objc(addVisitedPlacesObject:)
    @NSManaged public func addToVisitedPlaces(_ value: CDVisitedPlace)

    @objc(removeVisitedPlacesObject:)
    @NSManaged public func removeFromVisitedPlaces(_ value: CDVisitedPlace)

    @objc(addVisitedPlaces:)
    @NSManaged public func addToVisitedPlaces(_ values: NSSet)

    @objc(removeVisitedPlaces:)
    @NSManaged public func removeFromVisitedPlaces(_ values: NSSet)

}

extension CDTrip : Identifiable {

}
