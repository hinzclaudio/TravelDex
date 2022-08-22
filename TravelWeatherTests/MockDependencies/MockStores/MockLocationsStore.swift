//
//  MockLocationsStore.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxSwift
@testable import TravelWeather



class MockLocationsStore: LocationsStoreType {
    
    let error: Observable<Error> = Observable
        .create { observer in
            observer.onError(MockLocationErrorAPI.MockError.mockedErrorCase)
            return Disposables.create()
        }
    
    private(set) var addLocationCalled = false
    func add(_ location: Observable<Location>) -> Disposable {
        location
            .subscribe(onNext: { [weak self] _ in self?.addLocationCalled = true })
    }
    
    private(set) var allLocationsCalled = false
    func allLocations() -> Observable<[Location]> {
        Observable
            .just(MockLocationAPI.mockedLocations)
            .do(onNext: { [weak self] _ in self?.allLocationsCalled = true })
    }
    
    private(set) var locationsForQueryCalled = false
    func locations(for query: Observable<String>, bag: DisposeBag) -> Observable<[Location]> {
        let mockAPI = MockLocationAPI()
        return query
            .do(onNext: { [weak self] _ in self?.locationsForQueryCalled = true })
            .flatMapLatest { mockAPI.getLocations(search: $0) }
    }
    
}
