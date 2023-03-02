// Generated using Sourcery 2.0.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation


extension CDTrip {

    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: If you want to copy values from another entity, you may want to check __copied(valuesFrom:)__ 
    func safeInit(
        dummyBit: Bool,
        descr: String?,
        id: UUID,
        members: String?,
        title: String,
        pinColorRed: Int16,
        pinColorGreen: Int16,
        pinColorBlue: Int16,
        visitedPlaces: NSSet
    ) {
        self.dummyBit = dummyBit
        self.descr = descr
        self.id = id
        self.members = members
        self.title = title
        self.pinColorRed = pinColorRed
        self.pinColorGreen = pinColorGreen
        self.pinColorBlue = pinColorBlue
        self.visitedPlaces = visitedPlaces
    }
    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: This init does not concern itself with relationships. You will have to set these yourself.
    func safeInitNeglectRelationShips(
        dummyBit: Bool,
        descr: String?,
        id: UUID,
        members: String?,
        title: String,
        pinColorRed: Int16,
        pinColorGreen: Int16,
        pinColorBlue: Int16
    ) {
        self.dummyBit = dummyBit
        self.descr = descr
        self.id = id
        self.members = members
        self.title = title
        self.pinColorRed = pinColorRed
        self.pinColorGreen = pinColorGreen
        self.pinColorBlue = pinColorBlue
    }
}

extension CDVisitedPlace {

    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: If you want to copy values from another entity, you may want to check __copied(valuesFrom:)__ 
    func safeInit(
        end: Date,
        id: UUID,
        pictureData: Data?,
        start: Date,
        text: String?,
        region: String?,
        name: String,
        latitude: Double,
        longitude: Double,
        country: String?,
        trip: CDTrip?
    ) {
        self.end = end
        self.id = id
        self.pictureData = pictureData
        self.start = start
        self.text = text
        self.region = region
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.trip = trip
    }
    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: This init does not concern itself with relationships. You will have to set these yourself.
    func safeInitNeglectRelationShips(
        end: Date,
        id: UUID,
        pictureData: Data?,
        start: Date,
        text: String?,
        region: String?,
        name: String,
        latitude: Double,
        longitude: Double,
        country: String?
    ) {
        self.end = end
        self.id = id
        self.pictureData = pictureData
        self.start = start
        self.text = text
        self.region = region
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
    }
}


