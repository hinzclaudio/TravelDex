//
//  Trip.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import UIKit



typealias TripID = UUID
struct Trip: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let id: TripID
    let title: String
    let descr: String?
    let members: String?
    let visitedLocations: [UUID]
    let start: Date?
    let end: Date?
    let pinColorRed: UInt8
    let pinColorGreen: UInt8
    let pinColorBlue: UInt8
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:Trip.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: TripID, 
        title: String, 
        descr: String? = nil, 
        members: String? = nil, 
        visitedLocations: [UUID], 
        start: Date? = nil, 
        end: Date? = nil, 
        pinColorRed: UInt8, 
        pinColorGreen: UInt8, 
        pinColorBlue: UInt8
    )
    {
        self.id = id
        self.title = title
        self.descr = descr
        self.members = members
        self.visitedLocations = visitedLocations
        self.start = start
        self.end = end
        self.pinColorRed = pinColorRed
        self.pinColorGreen = pinColorGreen
        self.pinColorBlue = pinColorBlue
    }
    static var builder: TripBuilder {
        TripBuilder()
    }
    func cloneBuilder() -> TripBuilder {
        Trip.builder
            .with(id: self.id)
            .with(title: self.title)
            .with(descr: self.descr)
            .with(members: self.members)
            .with(visitedLocations: self.visitedLocations)
            .with(start: self.start)
            .with(end: self.end)
            .with(pinColorRed: self.pinColorRed)
            .with(pinColorGreen: self.pinColorGreen)
            .with(pinColorBlue: self.pinColorBlue)
    }
// sourcery:end
}
// sourcery:inline:after-auto:Trip.AutoBuilder-Builder
// MARK: - Builder
class TripBuilder {


    private(set) var id: TripID?


    private(set) var title: String?


    private(set) var descr: String??


    private(set) var members: String??


    private(set) var visitedLocations: [UUID]?


    private(set) var start: Date??


    private(set) var end: Date??


    private(set) var pinColorRed: UInt8?


    private(set) var pinColorGreen: UInt8?


    private(set) var pinColorBlue: UInt8?

    func with(id: TripID) -> TripBuilder {
        self.id = id; return self
    }
    func with(title: String) -> TripBuilder {
        self.title = title; return self
    }
    func with(descr: String?) -> TripBuilder {
        self.descr = descr; return self
    }
    func with(members: String?) -> TripBuilder {
        self.members = members; return self
    }
    func with(visitedLocations: [UUID]) -> TripBuilder {
        self.visitedLocations = visitedLocations; return self
    }
    func with(start: Date?) -> TripBuilder {
        self.start = start; return self
    }
    func with(end: Date?) -> TripBuilder {
        self.end = end; return self
    }
    func with(pinColorRed: UInt8) -> TripBuilder {
        self.pinColorRed = pinColorRed; return self
    }
    func with(pinColorGreen: UInt8) -> TripBuilder {
        self.pinColorGreen = pinColorGreen; return self
    }
    func with(pinColorBlue: UInt8) -> TripBuilder {
        self.pinColorBlue = pinColorBlue; return self
    }
    func build() -> Trip? {
        guard
            let id = self.id,
            let title = self.title,
            let descr = self.descr,
            let members = self.members,
            let visitedLocations = self.visitedLocations,
            let start = self.start,
            let end = self.end,
            let pinColorRed = self.pinColorRed,
            let pinColorGreen = self.pinColorGreen,
            let pinColorBlue = self.pinColorBlue
        else { return nil }
        return Trip(
            id: id,
            title: title,
            descr: descr,
            members: members,
            visitedLocations: visitedLocations,
            start: start,
            end: end,
            pinColorRed: pinColorRed,
            pinColorGreen: pinColorGreen,
            pinColorBlue: pinColorBlue
        )
    }
}
// sourcery:end



// MARK: - Extension
extension Trip {
    
    static let defaultPinColorRed: UInt8 = 236
    static let defaultPinColorGreen: UInt8 = 90
    static let defaultPinColorBlue: UInt8 = 86
    static var defaultPinColor: UIColor {
        .init(hex:
                String(
                    format:"%02X%02X%02X",
                    defaultPinColorRed,
                    defaultPinColorGreen,
                    defaultPinColorBlue
                )
        )!
    }
    
    var pinColor: UIColor {
        let hexFmt = String(format:"%02X%02X%02X", pinColorRed, pinColorGreen, pinColorBlue)
        return UIColor(hex: hexFmt)!
    }
    
}
