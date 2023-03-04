//
//  MockLocationsStore.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxSwift
@testable import TravelDex



class MockLocationsStore: LocationsStoreType {
    
    let error: Observable<Error> = Observable
        .create { observer in
            observer.onError(MockLocationErrorAPI.MockError.mockedErrorCase)
            return Disposables.create()
        }
    
    private(set) var allLocationsCalled = false
    func allLocations() -> Observable<[Location]> {
        Observable
            .just(MockLocationAPI.mockedLocations)
            .do(onNext: { [weak self] _ in self?.allLocationsCalled = true })
    }
    
    private(set) var locationsForQueryCalled = false
    func locations(for query: Observable<String>) -> Observable<[Location]> {
        let mockAPI = MockLocationAPI()
        return query
            .do(onNext: { [weak self] _ in self?.locationsForQueryCalled = true })
            .flatMapLatest { mockAPI.getLocations(search: $0) }
    }
    
    private(set) var locationForCoordinateCalled = false
    func location(for coordinate: Observable<Coordinate>) -> Observable<Location> {
        let mockAPI = MockLocationAPI()
        return coordinate
            .do(onNext: { [weak self] _ in self?.locationForCoordinateCalled = true })
            .flatMapLatest { mockAPI.getLocation(for: $0) }
    }
    
}
