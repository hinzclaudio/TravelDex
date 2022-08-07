//
//  VisitedPlace.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



struct VisitedPlace: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let id: UUID
    let name: String
    let descr: String?
    let picture: Data?
    let start: Date
    let end: Date
    let tripId: UUID
    let locationId: Int
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:VisitedPlace.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: UUID, 
        name: String, 
        descr: String? = nil, 
        picture: Data? = nil, 
        start: Date, 
        end: Date, 
        tripId: UUID, 
        locationId: Int
    )
    {
        self.id = id
        self.name = name
        self.descr = descr
        self.picture = picture
        self.start = start
        self.end = end
        self.tripId = tripId
        self.locationId = locationId
    }
    static var builder: VisitedPlaceBuilder {
        VisitedPlaceBuilder()
    }
    func cloneBuilder() -> VisitedPlaceBuilder {
        VisitedPlace.builder
            .with(id: self.id)
            .with(name: self.name)
            .with(descr: self.descr)
            .with(picture: self.picture)
            .with(start: self.start)
            .with(end: self.end)
            .with(tripId: self.tripId)
            .with(locationId: self.locationId)
    }
// sourcery:end
}
// sourcery:inline:after-auto:VisitedPlace.AutoBuilder-Builder
// MARK: - Builder
class VisitedPlaceBuilder {


    private(set) var id: UUID?


    private(set) var name: String?


    private(set) var descr: String??


    private(set) var picture: Data??


    private(set) var start: Date?


    private(set) var end: Date?


    private(set) var tripId: UUID?


    private(set) var locationId: Int?

    func with(id: UUID) -> VisitedPlaceBuilder {
        self.id = id; return self
    }
    func with(name: String) -> VisitedPlaceBuilder {
        self.name = name; return self
    }
    func with(descr: String?) -> VisitedPlaceBuilder {
        self.descr = descr; return self
    }
    func with(picture: Data?) -> VisitedPlaceBuilder {
        self.picture = picture; return self
    }
    func with(start: Date) -> VisitedPlaceBuilder {
        self.start = start; return self
    }
    func with(end: Date) -> VisitedPlaceBuilder {
        self.end = end; return self
    }
    func with(tripId: UUID) -> VisitedPlaceBuilder {
        self.tripId = tripId; return self
    }
    func with(locationId: Int) -> VisitedPlaceBuilder {
        self.locationId = locationId; return self
    }
    func build() -> VisitedPlace? {
        guard
            let id = self.id,
            let name = self.name,
            let descr = self.descr,
            let picture = self.picture,
            let start = self.start,
            let end = self.end,
            let tripId = self.tripId,
            let locationId = self.locationId
        else { return nil }
        return VisitedPlace(
            id: id,
            name: name,
            descr: descr,
            picture: picture,
            start: start,
            end: end,
            tripId: tripId,
            locationId: locationId
        )
    }
}
// sourcery:end
