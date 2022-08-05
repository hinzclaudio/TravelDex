//
//  CDLocation+CoreDataProperties.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//
//

import Foundation
import CoreData


extension CDLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDLocation> {
        return NSFetchRequest<CDLocation>(entityName: "CDLocation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var country: String?
    @NSManaged public var timezone: String?
    @NSManaged public var visitedPlaces: NSSet?
    @NSManaged public var weather: CDWeather?

}

// MARK: Generated accessors for visitedPlaces
extension CDLocation {

    @objc(addVisitedPlacesObject:)
    @NSManaged public func addToVisitedPlaces(_ value: CDVisitedPlace)

    @objc(removeVisitedPlacesObject:)
    @NSManaged public func removeFromVisitedPlaces(_ value: CDVisitedPlace)

    @objc(addVisitedPlaces:)
    @NSManaged public func addToVisitedPlaces(_ values: NSSet)

    @objc(removeVisitedPlaces:)
    @NSManaged public func removeFromVisitedPlaces(_ values: NSSet)

}

extension CDLocation : Identifiable {

}
