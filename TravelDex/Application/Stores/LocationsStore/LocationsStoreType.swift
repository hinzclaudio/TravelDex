//
//  LocationsStoreType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol LocationsStoreType {
    
    // MARK: - Output
    var error: Observable<Error> { get }
    
    func allLocations() -> Observable<[Location]>
    func locations(for query: Observable<String>) -> Observable<[Location]>
    func location(for coordinate: Observable<Coordinate>) -> Observable<Location>
    
}
