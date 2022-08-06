//
//  Location.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



struct Location: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let id: UUID
    let name: String
    let region: String?
    let country: String
    let timezone: String
    let coordinate: Coordinate
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:Location.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: UUID, 
        name: String, 
        region: String? = nil, 
        country: String, 
        timezone: String, 
        coordinate: Coordinate
    )
    {
        self.id = id
        self.name = name
        self.region = region
        self.country = country
        self.timezone = timezone
        self.coordinate = coordinate
    }
    static var builder: LocationBuilder {
        LocationBuilder()
    }
    func cloneBuilder() -> LocationBuilder {
        Location.builder
            .with(id: self.id)
            .with(name: self.name)
            .with(region: self.region)
            .with(country: self.country)
            .with(timezone: self.timezone)
            .with(coordinate: self.coordinate)
    }
// sourcery:end
}
// sourcery:inline:after-auto:Location.AutoBuilder-Builder
// MARK: - Builder
class LocationBuilder {


    private(set) var id: UUID?


    private(set) var name: String?


    private(set) var region: String??


    private(set) var country: String?


    private(set) var timezone: String?


    private(set) var coordinate: Coordinate?

    func with(id: UUID) -> LocationBuilder {
        self.id = id; return self
    }
    func with(name: String) -> LocationBuilder {
        self.name = name; return self
    }
    func with(region: String?) -> LocationBuilder {
        self.region = region; return self
    }
    func with(country: String) -> LocationBuilder {
        self.country = country; return self
    }
    func with(timezone: String) -> LocationBuilder {
        self.timezone = timezone; return self
    }
    func with(coordinate: Coordinate) -> LocationBuilder {
        self.coordinate = coordinate; return self
    }
    func build() -> Location? {
        guard
            let id = self.id,
            let name = self.name,
            let region = self.region,
            let country = self.country,
            let timezone = self.timezone,
            let coordinate = self.coordinate
        else { return nil }
        return Location(
            id: id,
            name: name,
            region: region,
            country: country,
            timezone: timezone,
            coordinate: coordinate
        )
    }
}
// sourcery:end
