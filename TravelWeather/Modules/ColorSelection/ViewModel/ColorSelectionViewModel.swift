//
//  ColorSelectionViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 28.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class ColorSelectionViewModel: ColorSelectionViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies, trip: Trip) {
        self.dependencies = dependencies
        self.trip = dependencies.tripsStore
            .trip(identifiedBy: .just(trip.id))
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: trip)
    }
    
    
    let trip: Driver<Trip>
    
    let availableColors: Driver<[UIColor]> = .just(Colors.pickerColors)
    
    func select(_ color: Observable<UIColor>) -> Disposable {
        let updatedTrip = color
            .withLatestFrom(trip) { c, trip -> Trip? in
                let comps = c.cgColor.components
                guard let comps = comps, comps.count == 4 else { return nil }
                let r = UInt8(comps[0] * 255)
                let g = UInt8(comps[1] * 255)
                let b = UInt8(comps[2] * 255)
                
                return trip.cloneBuilder()
                    .with(pinColorRed: r)
                    .with(pinColorGreen: g)
                    .with(pinColorBlue: b)
                    .build()!
            }
            .compactMap { $0 }
        
        let updateAction = dependencies.tripsStore
            .update(updatedTrip)
        let coordinatorAction = updatedTrip
            .subscribe(
                onNext: { [weak self] _ in self?.coordinator?.modalController?.dismiss(animated: true) }
            )
        
        return Disposables.create {
            updateAction.dispose()
            coordinatorAction.dispose()
        }
    }
    
}
