//
//  Location.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



typealias LocationID = Int 
struct Location: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let id: LocationID
    let name: String
    let region: String?
    let country: String
    let coordinate: Coordinate
    let queryParameter: String
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:Location.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: LocationID, 
        name: String, 
        region: String? = nil, 
        country: String, 
        coordinate: Coordinate, 
        queryParameter: String
    )
    {
        self.id = id
        self.name = name
        self.region = region
        self.country = country
        self.coordinate = coordinate
        self.queryParameter = queryParameter
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
            .with(coordinate: self.coordinate)
            .with(queryParameter: self.queryParameter)
    }
// sourcery:end
}
// sourcery:inline:after-auto:Location.AutoBuilder-Builder
// MARK: - Builder
class LocationBuilder {


    private(set) var id: LocationID?


    private(set) var name: String?


    private(set) var region: String??


    private(set) var country: String?


    private(set) var coordinate: Coordinate?


    private(set) var queryParameter: String?

    func with(id: LocationID) -> LocationBuilder {
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
    func with(coordinate: Coordinate) -> LocationBuilder {
        self.coordinate = coordinate; return self
    }
    func with(queryParameter: String) -> LocationBuilder {
        self.queryParameter = queryParameter; return self
    }
    func build() -> Location? {
        guard
            let id = self.id,
            let name = self.name,
            let region = self.region,
            let country = self.country,
            let coordinate = self.coordinate,
            let queryParameter = self.queryParameter
        else { return nil }
        return Location(
            id: id,
            name: name,
            region: region,
            country: country,
            coordinate: coordinate,
            queryParameter: queryParameter
        )
    }
}
// sourcery:end
