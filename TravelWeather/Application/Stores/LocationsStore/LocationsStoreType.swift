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
    var isLoading: ActivityIndicator { get }
    var error: Observable<Error> { get }
    func locations(for query: Observable<String>, bag: DisposeBag) -> Observable<[Location]>
    
}
