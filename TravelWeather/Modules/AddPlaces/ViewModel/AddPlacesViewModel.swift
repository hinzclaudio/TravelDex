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
        ) { _ in
            // TODO: Implement
        }
        
        let editTextAction = UIAction(
            title: "Edit Text",
            image: SFSymbol.pencil.image
        ) { _ in
            // TODO: Implement
        }
        let editStartAction = UIAction(
            title: "Edit Start",
            image: SFSymbol.calendar.image
        ) { _ in
            // TODO: Implement
        }
        let editEndAction = UIAction(
            title: "Edit End",
            image: SFSymbol.calendar.image
        ) { _ in
            // TODO: Implement
        }
        let editMenu = UIMenu(
            title: "Edit...",
            options: .displayInline,
            children: [editTextAction, editStartAction, editEndAction]
        )
        
        let delAction = UIAction(
            title: "Delete",
            image: SFSymbol.trash.image,
            attributes: .destructive
        ) { [weak self] _ in
            self?.dependencies.placesStore.delete(item.visitedPlace)
        }
        return UIMenu(
            title: item.location.name,
            children: [addImgAction, showOnMapAction, editMenu, delAction]
        )
    }
    
}
