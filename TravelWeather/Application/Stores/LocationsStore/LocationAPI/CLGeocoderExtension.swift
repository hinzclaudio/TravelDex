//
//  CLGeocoderExtension.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import RxSwift
import CoreLocation



extension CLGeocoder: LocationAPIType {
    
    func getLocation(for coordinate: Coordinate) -> Observable<Location> {
        self.rx.clPlacemarks(for: coordinate)
            .asLocations
            .compactMap { $0.first }
    }
    
    func getLocations(search: String) -> Observable<[Location]> {
        self.rx
            .clPlacemarks(for: search)
            .asLocations
    }
    
}
