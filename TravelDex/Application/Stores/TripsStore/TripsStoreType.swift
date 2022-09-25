//
//  TripsStoreType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



protocol TripsStoreType {
    
    // MARK: - Input
    func update(_ trip: Observable<Trip>) -> Disposable
    func delete(_ trip: Observable<Trip>) -> Disposable
    /// This should return a URL that points to a location where the export can be found.
    func export(_ trip: Trip) -> Observable<URL>
    
    
    // MARK: - Output
    func trips(forSearch query: String) -> Observable<[Trip]>
    func trip(identifiedBy id: Observable<UUID>) -> Observable<Trip?>
    
}
