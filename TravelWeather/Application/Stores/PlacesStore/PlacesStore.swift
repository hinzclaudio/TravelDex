//
//  PlacesStore.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import CoreData
import RxSwift



class PlacesStore: PlacesStoreType {
    
    let context: NSManagedObjectContext
    let dispatch: (CDAction) -> Void
    
    init(context: NSManagedObjectContext, dispatch: @escaping (CDAction) -> Void) {
        self.context = context
        self.dispatch = dispatch
    }
    
    
    
    // MARK: - Input
    func add(_ location: Location, to trip: Trip) {
        let place = VisitedPlace(
            id: UUID(),
            text: nil,
            picture: nil,
            start: .now,
            end: .now,
            tripId: trip.id,
            locationId: location.id
        )
        dispatch(CDUpdatePlace(place: place))
    }
    
    func delete(_ visitedPlace: VisitedPlace) {
        dispatch(
            CDDeleteVisitedPlace(visitedPlaceId: visitedPlace.id)
        )
    }
    
    func update(_ visitedPlace: VisitedPlace) {
        dispatch(CDUpdatePlace(place: visitedPlace))
    }
    
    
    // MARK: - Output
    func addedPlaces(for trip: Observable<UUID>) -> Observable<[AddedPlaceItem]> {
        trip
            .map { tripId -> NSFetchRequest<CDVisitedPlace> in
                let query = CDVisitedPlace.fetchRequest()
                query.predicate = NSPredicate(format: "trip.id == %@", tripId as CVarArg)
                query.sortDescriptors = [
                    NSSortDescriptor(key: "start", ascending: true),
                    NSSortDescriptor(key: "location.name", ascending: true)
                ]
                return query
            }
            .flatMapLatest { [weak self] query -> Observable<[AddedPlaceItem]> in
                guard let self = self else { return .just([]) }
                return CDObservable(fetchRequest: query, context: self.context)
                    .map { cdPlaces in
                        cdPlaces
                            .map { cdPlace in
                                AddedPlaceItem(
                                    visitedPlace: cdPlace.pureRepresentation,
                                    location: cdPlace.location.pureRepresentation
                                )
                            }
                    }
            }
    }
    
    func place(identifiedBy id: Observable<VisitedPlaceID>) -> Observable<AddedPlaceItem?> {
        id
            .map { placeId -> NSFetchRequest<CDVisitedPlace> in
                let query = CDVisitedPlace.fetchRequest()
                query.predicate = NSPredicate(format: "id == %@", placeId as CVarArg)
                query.fetchLimit = 1
                return query
            }
            .flatMapLatest { [weak self] query -> Observable<AddedPlaceItem?> in
                guard let self = self else { return .just(nil) }
                return CDObservable(fetchRequest: query, context: self.context)
                    .map { cdPlaces in cdPlaces.first }
                    .map { cdPlace in
                        if let cdPlace = cdPlace {
                            return AddedPlaceItem(
                                visitedPlace: cdPlace.pureRepresentation,
                                location: cdPlace.location.pureRepresentation
                            )
                        } else {
                            return nil
                        }
                    }
            }
    }
    
}
