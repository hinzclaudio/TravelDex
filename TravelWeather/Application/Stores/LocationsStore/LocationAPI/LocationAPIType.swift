//
//  LocationAPIType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import RxSwift



protocol LocationAPIType {
    func getLocation(for coordinate: Coordinate) -> Observable<Location>
    func getLocations(search: String) -> Observable<[Location]>
}
