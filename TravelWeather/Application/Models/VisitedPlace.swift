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
    let locationId: Int
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:VisitedPlace.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: UUID, 
        locationId: Int
    )
    {
        self.id = id
        self.locationId = locationId
    }
    static var builder: VisitedPlaceBuilder {
        VisitedPlaceBuilder()
    }
    func cloneBuilder() -> VisitedPlaceBuilder {
        VisitedPlace.builder
            .with(id: self.id)
            .with(locationId: self.locationId)
    }
// sourcery:end
}
// sourcery:inline:after-auto:VisitedPlace.AutoBuilder-Builder
// MARK: - Builder
class VisitedPlaceBuilder {


    private(set) var id: UUID?


    private(set) var locationId: Int?

    func with(id: UUID) -> VisitedPlaceBuilder {
        self.id = id; return self
    }
    func with(locationId: Int) -> VisitedPlaceBuilder {
        self.locationId = locationId; return self
    }
    func build() -> VisitedPlace? {
        guard
            let id = self.id,
            let locationId = self.locationId
        else { return nil }
        return VisitedPlace(
            id: id,
            locationId: locationId
        )
    }
}
// sourcery:end
