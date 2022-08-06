//
//  Coordinatr.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



struct Coordinate: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let latitude: Double
    let longitude: Double
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:Coordinate.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        latitude: Double, 
        longitude: Double
    )
    {
        self.latitude = latitude
        self.longitude = longitude
    }
    static var builder: CoordinateBuilder {
        CoordinateBuilder()
    }
    func cloneBuilder() -> CoordinateBuilder {
        Coordinate.builder
            .with(latitude: self.latitude)
            .with(longitude: self.longitude)
    }
// sourcery:end
}
// sourcery:inline:after-auto:Coordinate.AutoBuilder-Builder
// MARK: - Builder
class CoordinateBuilder {


    private(set) var latitude: Double?


    private(set) var longitude: Double?

    func with(latitude: Double) -> CoordinateBuilder {
        self.latitude = latitude; return self
    }
    func with(longitude: Double) -> CoordinateBuilder {
        self.longitude = longitude; return self
    }
    func build() -> Coordinate? {
        guard
            let latitude = self.latitude,
            let longitude = self.longitude
        else { return nil }
        return Coordinate(
            latitude: latitude,
            longitude: longitude
        )
    }
}
// sourcery:end
