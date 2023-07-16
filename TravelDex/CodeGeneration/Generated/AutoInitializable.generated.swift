// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation


extension CDLocation {

    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: If you want to copy values from another entity, you may want to check __copied(valuesFrom:)__ 
    func safeInit(
        id: UUID,
        latitude: Double,
        longitude: Double,
        name: String,
        region: String?,
        country: String?,
        timezoneIdentifier: String?,
        visitedPlaces: NSSet
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.region = region
        self.country = country
        self.timezoneIdentifier = timezoneIdentifier
        self.visitedPlaces = visitedPlaces
    }
    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: This init does not concern itself with relationships. You will have to set these yourself.
    func safeInitNeglectRelationShips(
        id: UUID,
        latitude: Double,
        longitude: Double,
        name: String,
        region: String?,
        country: String?,
        timezoneIdentifier: String?
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.region = region
        self.country = country
        self.timezoneIdentifier = timezoneIdentifier
    }
}

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
        id: UUID,
        text: String?,
        pictureData: Data?,
        start: Date,
        end: Date,
        location: CDLocation,
        trip: CDTrip
    ) {
        self.id = id
        self.text = text
        self.pictureData = pictureData
        self.start = start
        self.end = end
        self.location = location
        self.trip = trip
    }
    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: This init does not concern itself with relationships. You will have to set these yourself.
    func safeInitNeglectRelationShips(
        id: UUID,
        text: String?,
        pictureData: Data?,
        start: Date,
        end: Date
    ) {
        self.id = id
        self.text = text
        self.pictureData = pictureData
        self.start = start
        self.end = end
    }
}


