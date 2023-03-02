//
//  VisitedPlace.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



typealias VisitedPlaceID = UUID
struct VisitedPlace: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let id: VisitedPlaceID
    let text: String?
    let picture: Data?
    let start: Date
    let end: Date
    let tripId: TripID?
    let location: Location
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:VisitedPlace.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: VisitedPlaceID, 
        text: String? = nil, 
        picture: Data? = nil, 
        start: Date, 
        end: Date, 
        tripId: TripID? = nil, 
        location: Location
    )
    {
        self.id = id
        self.text = text
        self.picture = picture
        self.start = start
        self.end = end
        self.tripId = tripId
        self.location = location
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
            .with(location: self.location)
    }
// sourcery:end
}
// sourcery:inline:after-auto:VisitedPlace.AutoBuilder-Builder
// MARK: - Builder
class VisitedPlaceBuilder {


    private(set) var id: VisitedPlaceID?


    private(set) var text: String??


    private(set) var picture: Data??


    private(set) var start: Date?


    private(set) var end: Date?


    private(set) var tripId: TripID??


    private(set) var location: Location?

    func with(id: VisitedPlaceID) -> VisitedPlaceBuilder {
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
    func with(tripId: TripID?) -> VisitedPlaceBuilder {
        self.tripId = tripId; return self
    }
    func with(location: Location) -> VisitedPlaceBuilder {
        self.location = location; return self
    }
    func build() -> VisitedPlace? {
        guard
            let id = self.id,
            let text = self.text,
            let picture = self.picture,
            let start = self.start,
            let end = self.end,
            let tripId = self.tripId,
            let location = self.location
        else { return nil }
        return VisitedPlace(
            id: id,
            text: text,
            picture: picture,
            start: start,
            end: end,
            tripId: tripId,
            location: location
        )
    }
}
// sourcery:end
