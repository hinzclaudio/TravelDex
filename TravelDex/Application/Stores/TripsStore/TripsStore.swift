//
//  TripsStore.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import CoreData



class TripsStore: TripsStoreType {
    
    let context: NSManagedObjectContext
    let dispatch: (CDAction) -> Void
    
    init(context: NSManagedObjectContext, dispatch: @escaping (CDAction) -> Void) {
        self.context = context
        self.dispatch = dispatch
    }
    
    
    
    // MARK: - Input
    func update(_ trip: Observable<Trip>) -> Disposable {
        trip
            .map { CDUpdateTrip(trip: $0) }
            .subscribe(onNext: { [weak self] in self?.dispatch($0) } )
    }
    
    func delete(_ trip: Observable<Trip>) -> Disposable {
        trip
            .map { CDDeleteTrip(trip: $0) }
            .subscribe(onNext: { [weak self] in self?.dispatch($0) })
    }
    
    func export(_ trip: Trip) -> Observable<URL> {
        Observable
            .create { [weak self] observer in
                self?.dispatch(
                    CDExportTrip(tripId: trip.id) { result in
                        switch result {
                        case .success(let url):
                            observer.onNext(url)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                )
                return Disposables.create()
            }
    }
    
    func importData(from fileURL: URL, inPlace: Bool) -> Observable<Trip> {
        Observable
            .create { observer in
                let action = CDImportTrip(fileURL: fileURL, inPlace: inPlace) { result in
                    switch result {
                    case .success(let trip):
                        observer.onNext(trip)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                self.dispatch(action)
                return Disposables.create()
            }
    }
    
    
    // MARK: - Output
    func trips(forSearch query: String = "") -> Observable<[Trip]> {
        let tripsQuery = CDTrip.fetchRequest()
        if !query.isEmpty {
            tripsQuery.predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR descr CONTAINS[cd] %@ OR members CONTAINS[cd] %@",
                query, query, query
            )
        }
        
        return CDObservable(fetchRequest: tripsQuery, context: context)
            .map { trips in
                trips
                    .sortedByPlaces
                    .map { trip in trip.pureRepresentation }
            }
    }
    
    func trip(identifiedBy id: Observable<UUID>) -> Observable<Trip?> {
        return id
            .map { tripId -> NSFetchRequest<CDTrip> in
                let query = CDTrip.fetchRequest()
                query.predicate = NSPredicate(format: "id == %@", tripId as CVarArg)
                query.fetchLimit = 1
                return query
            }
            .flatMapLatest { [unowned self] query -> Observable<Trip?> in
                CDObservable(fetchRequest: query, context: self.context)
                    .map { $0.first?.pureRepresentation }
            }
    }
    
}
