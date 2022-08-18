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
    private let geoCoder: CLGeocoder
    
    init(context: NSManagedObjectContext, dispatch: @escaping (CDAction) -> Void, geoCoder: CLGeocoder) {
        self.context = context
        self.dispatch = dispatch
        self.geoCoder = geoCoder
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
                    return self.geoCoder.rx.locations(for: search)
                        .map { placemarks in
                            placemarks
                                .filter { $0.location != nil }
                                .map { mark -> Location in
                                    let regionString: String?
                                    if let locality = mark.locality {
                                        if let subLoc = mark.subLocality {
                                            regionString = "\(locality), \(subLoc)"
                                        } else{
                                            regionString = locality
                                        }
                                    } else {
                                        regionString = mark.subLocality
                                    }
                                    
                                    return Location(
                                        id: LocationID(),
                                        name: mark.name ?? "",
                                        region: regionString,
                                        country: mark.country,
                                        coordinate: Coordinate(
                                            latitude: mark.location!.coordinate.latitude,
                                            longitude: mark.location!.coordinate.longitude
                                        ),
                                        timezoneIdentifier: mark.timeZone?.identifier
                                    )
                                }
                        }
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
