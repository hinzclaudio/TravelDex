//
//  LocationsStoreType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol LocationsStoreType {
    
    var isLoading: ActivityIndicator { get }
    
    var error: Observable<Error> { get }
    
    func updateLocations(with query: Observable<String>) -> Disposable
    
    func locations(for query: Observable<String>) -> Observable<[Location]>
    
}
