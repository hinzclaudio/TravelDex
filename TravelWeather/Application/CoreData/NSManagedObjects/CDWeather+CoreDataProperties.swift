//
//  CDWeather+CoreDataProperties.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//
//

import Foundation
import CoreData


extension CDWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWeather> {
        return NSFetchRequest<CDWeather>(entityName: "CDWeather")
    }

    @NSManaged public var lastUpdate: Date?
    @NSManaged public var tempC: Int64
    @NSManaged public var feelslikeC: Int64
    @NSManaged public var conditionCode: String?
    @NSManaged public var conditionText: String?
    @NSManaged public var conditionIcon: String?
    @NSManaged public var windKph: Double
    @NSManaged public var windDegree: Int64
    @NSManaged public var pressureMb: Double
    @NSManaged public var precipMm: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var cloudCoverage: Int64
    @NSManaged public var uvIndex: Double
    @NSManaged public var location: CDLocation?

}

extension CDWeather : Identifiable {

}
