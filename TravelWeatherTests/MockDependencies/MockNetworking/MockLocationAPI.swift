//
//  MockLocationAPI.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import RxSwift
@testable import TravelWeather



class MockLocationAPI: LocationAPIType {
    
    // MARK: - Class Funcs
    static let berlin = Location(
        id: LocationID(),
        name: "Berlin",
        coordinate: Coordinate(latitude: 52.529, longitude: 13.381)
    )
    
    static let hamburg = Location(
        id: LocationID(),
        name: "Hamburg",
        coordinate: Coordinate(latitude: 53.548, longitude: 9.991)
    )
    
    static let bremen = Location(
        id: LocationID(),
        name: "Bremen",
        coordinate: Coordinate(latitude: 53.082, longitude: 8.816)
    )
    
    static var mockedLocations: [Location] {
        [berlin, hamburg, bremen]
    }
    
    
    // MARK: - Instance
    func getLocations(search: String) -> Observable<[Location]> {
        .just(MockLocationAPI.mockedLocations)
        .map { allLocations in
            allLocations
                .filter { loc in loc.name.lowercased().contains(search) }
        }
    }
    
}
