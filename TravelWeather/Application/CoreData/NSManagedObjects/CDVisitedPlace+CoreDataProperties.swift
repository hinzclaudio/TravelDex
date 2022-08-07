//
//  CDVisitedPlace+CoreDataProperties.swift
//  TravelWeather
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
    @NSManaged public var name: String
    @NSManaged public var descr: String?
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
