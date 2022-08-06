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
    let location: UUID
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:VisitedPlace.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: UUID, 
        location: UUID
    )
    {
        self.id = id
        self.location = location
    }
    static var builder: VisitedPlaceBuilder {
        VisitedPlaceBuilder()
    }
    func cloneBuilder() -> VisitedPlaceBuilder {
        VisitedPlace.builder
            .with(id: self.id)
            .with(location: self.location)
    }
// sourcery:end
}
// sourcery:inline:after-auto:VisitedPlace.AutoBuilder-Builder
// MARK: - Builder
class VisitedPlaceBuilder {


    private(set) var id: UUID?


    private(set) var location: UUID?

    func with(id: UUID) -> VisitedPlaceBuilder {
        self.id = id; return self
    }
    func with(location: UUID) -> VisitedPlaceBuilder {
        self.location = location; return self
    }
    func build() -> VisitedPlace? {
        guard
            let id = self.id,
            let location = self.location
        else { return nil }
        return VisitedPlace(
            id: id,
            location: location
        )
    }
}
// sourcery:end
