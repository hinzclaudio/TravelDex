//
//  TripsStore.swift
//  TravelWeather
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
    func addTrip(_ trip: Observable<Trip>) -> Disposable {
        trip
            .map { CDUpdateTrip(trip: $0) }
            .subscribe(onNext: { [weak self] in self?.dispatch($0) } )
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
                    .sorted { cdTrip0, cdTrip1 in
                        let start0 = cdTrip0.startDate
                        let start1 = cdTrip1.startDate
                        if let start0 = start0, let start1 = start1 {
                            return start0 < start1
                        } else if start0 != nil {
                            return true
                        } else if start1 != nil {
                            return false
                        } else {
                            return cdTrip0.title.localizedStandardCompare(cdTrip1.title) == .orderedAscending
                        }
                    }
                    .map { trip in
                        trip.pureRepresentation
                    }
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
