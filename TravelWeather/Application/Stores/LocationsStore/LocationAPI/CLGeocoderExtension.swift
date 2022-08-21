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
    func getLocations(search: String) -> Observable<[Location]> {
        self.rx
            .clPlacemarks(for: search)
            .asLocations
    }
    
}
