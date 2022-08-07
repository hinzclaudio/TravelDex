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



class LocationsStore: LocationsStoreType {
    
    private let context: NSManagedObjectContext
    private let dispatch: (CDAction) -> Void
    private let weatherAPI: WeatherAPIType
    
    init(context: NSManagedObjectContext, dispatch: @escaping (CDAction) -> Void, api: WeatherAPIType) {
        self.context = context
        self.dispatch = dispatch
        self.weatherAPI = api
    }
    
    
    let isLoading = ActivityIndicator()
    var apiError = PublishSubject<Error>()
    var error: Observable<Error> { apiError }
    
    
    func updateLocations(with query: Observable<String>) -> Disposable {
        let result = query
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .flatMapLatest { [weak self] query -> Observable<Event<[WeatherAPILocation]>> in
                guard let self = self else { return .just(.completed) }
                return self.weatherAPI.searchLocations(query)
                    .trackActivity(self.isLoading)
                    .materialize()
            }
            .share()
        
        let onSuccess = result
            .compactMap { response in response.event.element }
            .map { apiLocations -> [Location] in
                apiLocations
                    .map { apiLoc in
                        Location(
                            id: apiLoc.id,
                            name: apiLoc.name,
                            region: apiLoc.region,
                            country: apiLoc.country,
                            coordinate: Coordinate(
                                latitude: apiLoc.lat,
                                longitude: apiLoc.lon
                            ),
                            queryParameter: apiLoc.queryParameter
                        )
                    }
            }
            .map { CDUpdateLocations(locations: $0) }
            .subscribe(onNext: { [weak self] in self?.dispatch($0) })

        let onError = result
            .compactMap { response in response.event.error }
            .bind(to: apiError)

        return Disposables.create {
            onSuccess.dispose()
            onError.dispose()
        }
    }
    
    func locations(for query: Observable<String>) -> Observable<[Location]> {
        query
            .map { query -> NSFetchRequest<CDLocation> in
                let cdQuery = CDLocation.fetchRequest()
                cdQuery.sortDescriptors = [
                    NSSortDescriptor(key: "name", ascending: true),
                    NSSortDescriptor(key: "region", ascending: true),
                    NSSortDescriptor(key: "country", ascending: true)
                ]
                if !query.isEmpty {
                    cdQuery.predicate = NSPredicate(
                        format: "name CONTAINS[cd] %@ OR region CONTAINS[cd] %@ OR country CONTAINS[cd] %@",
                        query, query, query
                    )
                }
                return cdQuery
            }
            .flatMapLatest { [weak self] cdQuery -> Observable<[Location]> in
                guard let self = self else { return .just([]) }
                return CDObservable(fetchRequest: cdQuery, context: self.context)
                    .map { cdLocs in cdLocs.map { $0.pureRepresentation } }
            }
    }
    
}
