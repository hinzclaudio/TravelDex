//
//  AddPlacesViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class AddPlacesViewModel: AddPlacesViewModelType {
    
    weak var coordinator: AppCoordinator?

    typealias Dependencies = HasTripsStore & HasPlacesStore
    private let dependencies: Dependencies
    private let initialTrip: Trip
    
    init(dependencies: Dependencies, trip: Trip) {
        self.dependencies = dependencies
        self.initialTrip = trip
    }
    
    
    // MARK: - Input
    func addLocation(_ tapped: Observable<Void>) -> Disposable {
        tapped
            .withLatestFrom(trip)
            .subscribe(onNext: { [weak self] trip in
                self?.coordinator?
                    .searchLocation(completion: { location in
                        self?.dependencies.placesStore.add(location, to: trip)
                    })
            })
    }
    
    func set(_ item: AddedPlaceItem, expanded: Bool) {
        var newItems = _expandedItems.value
        if expanded {
            newItems.insert(item.visitedPlace.id)
        } else {
            newItems.remove(item.visitedPlace.id)
        }
        _expandedItems.accept(newItems)
    }
    
    func setStart(of item: AddedPlaceItem, to date: Date) {
        let newPlace = item.visitedPlace.cloneBuilder()
            .with(start: date)
            .build()!
        dependencies.placesStore.update(newPlace)
    }
    
    func setEnd(of item: AddedPlaceItem, to date: Date) {
        let newPlace = item.visitedPlace.cloneBuilder()
            .with(end: date)
            .build()!
        dependencies.placesStore.update(newPlace)
    }
    
    
    // MARK: - Output
    lazy var trip: Driver<Trip> = {
        dependencies.tripsStore
            .trip(identifiedBy: .just(initialTrip.id))
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: initialTrip)
    }()
    
    lazy var addedPlaces: Driver<[AddedPlaceItem]> = {
        dependencies.placesStore
            .addedPlaces(for: .just(initialTrip.id))
            .asDriver(onErrorJustReturn: [])
    }()
    
    let _expandedItems = BehaviorRelay<Set<VisitedPlaceID>>(value: [])
    lazy var expandedItems: Driver<Set<VisitedPlaceID>> = {
        _expandedItems
            .asDriver()
    }()
    
    
    // MARK: - Menu
    func menu(for item: AddedPlaceItem) -> UIMenu {
        let addImgAction = UIAction(
            title: "Add Image",
            image: SFSymbol.plus.image
        ) { _ in
            // TODO: Implement
        }
        let showOnMapAction = UIAction(
            title: "Show on Map",
            image: SFSymbol.map.image
        ) { [weak self] _ in
            self?.display(item.location, in: item.visitedPlace.tripId)
        }
        let editTextAction = UIAction(
            title: "Edit Text",
            image: SFSymbol.pencil.image
        ) { _ in
            // TODO: Implement
        }
        let delAction = UIAction(
            title: "Delete",
            image: SFSymbol.trash.image,
            attributes: .destructive
        ) { [weak self] _ in
            self?.delete(item)
        }
        return UIMenu(
            title: item.location.name,
            children: [addImgAction, showOnMapAction, editTextAction, delAction]
        )
    }
    
    private func delete(_ item: AddedPlaceItem) {
        set(item, expanded: false)
        dependencies.placesStore.delete(item.visitedPlace)
    }
    
    private func display(_ location: Location, in tripId: TripID) {
        coordinator?.display(location, in: tripId)
    }
    
}
