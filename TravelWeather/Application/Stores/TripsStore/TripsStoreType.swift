//
//  TripsStoreType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



protocol TripsStoreType {
    
    // MARK: - Input
    func addTrip(_ trip: Observable<Trip>) -> Disposable
    
    // MARK: - Output
    func trips(forSearch query: String) -> Observable<[Trip]>
    func trip(identifiedBy id: Observable<UUID>) -> Observable<Trip?>
    
}
