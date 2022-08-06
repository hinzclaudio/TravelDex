// Generated using Sourcery 1.8.2 — https://github.com/krzysztofzablocki/Sourcery
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
        country: String,
        timezone: String,
        visitedPlaces: NSSet,
        weather: CDWeather?
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.region = region
        self.country = country
        self.timezone = timezone
        self.visitedPlaces = visitedPlaces
        self.weather = weather
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
        country: String,
        timezone: String,
        visitedPlaces: NSSet,
        weather: CDWeather?
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.region = region
        self.country = country
        self.timezone = timezone
        self.visitedPlaces = visitedPlaces
        self.weather = weather
    }
}

extension CDTrip {

    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: If you want to copy values from another entity, you may want to check __copied(valuesFrom:)__ 
    func safeInit(
        id: UUID,
        title: String,
        descr: String?,
        members: String?,
        pictureData: Data?,
        visitedPlaces: NSSet
    ) {
        self.id = id
        self.title = title
        self.descr = descr
        self.members = members
        self.pictureData = pictureData
        self.visitedPlaces = visitedPlaces
    }
    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: This init does not concern itself with relationships. You will have to set these yourself.
    func safeInitNeglectRelationShips(
        id: UUID,
        title: String,
        descr: String?,
        members: String?,
        pictureData: Data?,
        visitedPlaces: NSSet
    ) {
        self.id = id
        self.title = title
        self.descr = descr
        self.members = members
        self.pictureData = pictureData
        self.visitedPlaces = visitedPlaces
    }
}

extension CDVisitedPlace {

    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: If you want to copy values from another entity, you may want to check __copied(valuesFrom:)__ 
    func safeInit(
        id: UUID,
        name: String,
        descr: String?,
        pictureData: Data?,
        start: Date,
        end: Date,
        location: CDLocation,
        trip: CDTrip
    ) {
        self.id = id
        self.name = name
        self.descr = descr
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
        name: String,
        descr: String?,
        pictureData: Data?,
        start: Date,
        end: Date,
        location: CDLocation,
        trip: CDTrip
    ) {
        self.id = id
        self.name = name
        self.descr = descr
        self.pictureData = pictureData
        self.start = start
        self.end = end
        self.location = location
        self.trip = trip
    }
}

extension CDWeather {

    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: If you want to copy values from another entity, you may want to check __copied(valuesFrom:)__ 
    func safeInit(
        lastUpdate: Date?,
        tempC: Int64,
        feelslikeC: Int64,
        conditionCode: String?,
        conditionText: String?,
        conditionIcon: String?,
        windKph: Double,
        windDegree: Int64,
        pressureMb: Double,
        precipMm: Double,
        humidity: Int64,
        cloudCoverage: Int64,
        uvIndex: Double,
        location: CDLocation?
    ) {
        self.lastUpdate = lastUpdate
        self.tempC = tempC
        self.feelslikeC = feelslikeC
        self.conditionCode = conditionCode
        self.conditionText = conditionText
        self.conditionIcon = conditionIcon
        self.windKph = windKph
        self.windDegree = windDegree
        self.pressureMb = pressureMb
        self.precipMm = precipMm
        self.humidity = humidity
        self.cloudCoverage = cloudCoverage
        self.uvIndex = uvIndex
        self.location = location
    }
    /// Acts as a proper initializer that forces the compiler to check if all attributes
    /// have been set correctly.
    /// - note: This init does not concern itself with relationships. You will have to set these yourself.
    func safeInitNeglectRelationShips(
        lastUpdate: Date?,
        tempC: Int64,
        feelslikeC: Int64,
        conditionCode: String?,
        conditionText: String?,
        conditionIcon: String?,
        windKph: Double,
        windDegree: Int64,
        pressureMb: Double,
        precipMm: Double,
        humidity: Int64,
        cloudCoverage: Int64,
        uvIndex: Double,
        location: CDLocation?
    ) {
        self.lastUpdate = lastUpdate
        self.tempC = tempC
        self.feelslikeC = feelslikeC
        self.conditionCode = conditionCode
        self.conditionText = conditionText
        self.conditionIcon = conditionIcon
        self.windKph = windKph
        self.windDegree = windDegree
        self.pressureMb = pressureMb
        self.precipMm = precipMm
        self.humidity = humidity
        self.cloudCoverage = cloudCoverage
        self.uvIndex = uvIndex
        self.location = location
    }
}


