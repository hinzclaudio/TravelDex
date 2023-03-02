//
//  Location.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



typealias LocationID = UUID
struct Location: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let name: String
    let region: String?
    let country: String?
    let coordinate: Coordinate
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:Location.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        name: String, 
        region: String? = nil, 
        country: String? = nil, 
        coordinate: Coordinate
    )
    {
        self.name = name
        self.region = region
        self.country = country
        self.coordinate = coordinate
    }
    static var builder: LocationBuilder {
        LocationBuilder()
    }
    func cloneBuilder() -> LocationBuilder {
        Location.builder
            .with(name: self.name)
            .with(region: self.region)
            .with(country: self.country)
            .with(coordinate: self.coordinate)
    }
// sourcery:end
}
// sourcery:inline:after-auto:Location.AutoBuilder-Builder
// MARK: - Builder
class LocationBuilder {


    private(set) var name: String?


    private(set) var region: String??


    private(set) var country: String??


    private(set) var coordinate: Coordinate?

    func with(name: String) -> LocationBuilder {
        self.name = name; return self
    }
    func with(region: String?) -> LocationBuilder {
        self.region = region; return self
    }
    func with(country: String?) -> LocationBuilder {
        self.country = country; return self
    }
    func with(coordinate: Coordinate) -> LocationBuilder {
        self.coordinate = coordinate; return self
    }
    func build() -> Location? {
        guard
            let name = self.name,
            let region = self.region,
            let country = self.country,
            let coordinate = self.coordinate
        else { return nil }
        return Location(
            name: name,
            region: region,
            country: country,
            coordinate: coordinate
        )
    }
}
// sourcery:end



extension Location {
    
    var supplementaryString: String? {
        if let country = country {
            if let region = region {
                return "\(country), \(region)"
            } else {
                return country
            }
        } else {
            return region
        }
    }
    
}
