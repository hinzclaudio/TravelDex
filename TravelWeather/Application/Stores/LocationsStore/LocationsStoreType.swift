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
    
    // MARK: - Input
    func add(_ location: Observable<Location>) -> Disposable
    
    
    // MARK: - Output
    var error: Observable<Error> { get }
    
    func allLocations() -> Observable<[Location]>
    func locations(for query: Observable<String>, bag: DisposeBag) -> Observable<[Location]>
    
}
