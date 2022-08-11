//
//  VisitedPlace.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



typealias VisitedPlaceID = UUID
struct VisitedPlace: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let id: UUID
    let text: String?
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
        text: String? = nil, 
        picture: Data? = nil, 
        start: Date, 
        end: Date, 
        tripId: UUID, 
        locationId: Int
    )
    {
        self.id = id
        self.text = text
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
            .with(text: self.text)
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


    private(set) var text: String??


    private(set) var picture: Data??


    private(set) var start: Date?


    private(set) var end: Date?


    private(set) var tripId: UUID?


    private(set) var locationId: Int?

    func with(id: UUID) -> VisitedPlaceBuilder {
        self.id = id; return self
    }
    func with(text: String?) -> VisitedPlaceBuilder {
        self.text = text; return self
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
            let text = self.text,
            let picture = self.picture,
            let start = self.start,
            let end = self.end,
            let tripId = self.tripId,
            let locationId = self.locationId
        else { return nil }
        return VisitedPlace(
            id: id,
            text: text,
            picture: picture,
            start: start,
            end: end,
            tripId: tripId,
            locationId: locationId
        )
    }
}
// sourcery:end
