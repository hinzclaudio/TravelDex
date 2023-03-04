//
//  MockLocationAPI.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import RxSwift
@testable import TravelDex



class MockLocationAPI: LocationAPIType {
    
    // MARK: - Class Funcs
    static let berlin = Location(
        name: "Berlin",
        coordinate: Coordinate(latitude: 52.529, longitude: 13.381)
    )
    
    static let hamburg = Location(
        name: "Hamburg",
        region: "Hamburg",
        country: "Germany",
        coordinate: Coordinate(latitude: 53.548, longitude: 9.991)
    )
    
    static let bremen = Location(
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
                .filter { loc in loc.name.lowercased().contains(search.lowercased()) }
        }
    }
    
    func getLocation(for coordinate: Coordinate) -> Observable<Location> {
        .just(MockLocationAPI.hamburg)
    }
    
}
