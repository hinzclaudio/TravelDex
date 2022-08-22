//
//  LocationsStore.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa
import CoreLocation



class LocationsStore: LocationsStoreType {
    
    private let context: NSManagedObjectContext
    private let dispatch: (CDAction) -> Void
    private let locationAPI: LocationAPIType
    
    init(
        context: NSManagedObjectContext,
        dispatch: @escaping (CDAction) -> Void,
        locationAPI: LocationAPIType
    ) {
        self.context = context
        self.dispatch = dispatch
        self.locationAPI = locationAPI
    }
    
    var apiError = PublishSubject<Error>()
    var error: Observable<Error> { apiError }
    
    
    func add(_ location: Observable<Location>) -> Disposable {
        location
            .map { CDUpdateLocations(locations: [$0]) }
            .subscribe(onNext: { [weak self] in self?.dispatch($0) })
    }
    
    func allLocations() -> Observable<[Location]> {
        let query = CDLocation.fetchRequest()
        query.sortDescriptors = [
            NSSortDescriptor(key: "country", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return CDObservable(fetchRequest: query, context: context)
            .map { cdLocs in cdLocs.map { $0.pureRepresentation } }
    }
    
    func locations(for query: Observable<String>, bag: DisposeBag) -> Observable<[Location]> {
        let result = query
            .flatMapLatest { [unowned self] search -> Observable<Event<[Location]>> in
                if search.isEmpty {
                    return self.allLocations()
                        .materialize()
                } else {
                    return self.locationAPI
                        .getLocations(search: search)
                        .materialize()
                }
            }
            .share()
        
        result
            .compactMap { $0.event.error }
            .bind(to: apiError)
            .disposed(by: bag)
        
        return result
            .compactMap { $0.event.element }
    }
    
}
