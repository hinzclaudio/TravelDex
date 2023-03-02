//
//  PlacesStore.swift
//  TravelDex
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
            location: Location(
                name: location.name,
                region: location.region,
                country: location.country,
                coordinate: location.coordinate
            )
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
    func allPlaces() -> Observable<[AddedPlaceItem]> {
        let query = CDVisitedPlace.fetchRequest()
        query.sortDescriptors = [
            NSSortDescriptor(key: "start", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return CDObservable(fetchRequest: query, context: context)
            .map { cdPlaces in
                cdPlaces
                    .map { cdPlace in
                        AddedPlaceItem(
                            visitedPlace: cdPlace.pureRepresentation,
                            location: cdPlace.pureRepresentation.location,
                            pinColor: cdPlace.trip?.pureRepresentation.pinColor ?? Trip.defaultPinColor
                        )
                    }
            }
    }
    
    func places(for trip: Observable<UUID>) -> Observable<[AddedPlaceItem]> {
        trip
            .map { tripId -> NSFetchRequest<CDVisitedPlace> in
                let query = CDVisitedPlace.fetchRequest()
                query.predicate = NSPredicate(format: "trip.id == %@", tripId as CVarArg)
                query.sortDescriptors = [
                    NSSortDescriptor(key: "start", ascending: true),
                    NSSortDescriptor(key: "name", ascending: true)
                ]
                return query
            }
            .flatMapLatest { [unowned self] query -> Observable<[AddedPlaceItem]> in
                CDObservable(fetchRequest: query, context: self.context)
                    .map { cdPlaces in
                        cdPlaces
                            .map { cdPlace in
                                AddedPlaceItem(
                                    visitedPlace: cdPlace.pureRepresentation,
                                    location: cdPlace.pureRepresentation.location,
                                    pinColor: cdPlace.trip?.pureRepresentation.pinColor ?? Trip.defaultPinColor
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
            .flatMapLatest { [unowned self] query -> Observable<AddedPlaceItem?> in
                CDObservable(fetchRequest: query, context: self.context)
                    .map { cdPlaces in cdPlaces.first }
                    .map { cdPlace in
                        if let cdPlace = cdPlace {
                            return AddedPlaceItem(
                                visitedPlace: cdPlace.pureRepresentation,
                                location: cdPlace.pureRepresentation.location,
                                pinColor: cdPlace.trip?.pureRepresentation.pinColor ?? Trip.defaultPinColor
                            )
                        } else {
                            return nil
                        }
                    }
            }
    }
    
}
