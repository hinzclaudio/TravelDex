//
//  LocationEntryViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 27.08.22.
//

import Foundation
import RxSwift
import RxRelay



class LocationEntryViewModel: LocationEntryViewModelType {
    
    weak var coordinator: LocationSearchCoordinator?
    
    typealias Dependencies = HasLocationsStore
    private let dependencies: Dependencies
    private let coordinate: Coordinate
    
    init(dependencies: Dependencies, coordinate: Coordinate) {
        self.dependencies = dependencies
        self.coordinate = coordinate
    }
    
    
    let title = BehaviorRelay(value: "")
    let region = BehaviorRelay<String?>(value: nil)
    let country = BehaviorRelay<String?>(value: nil)
    
    func confirm(_ tapped: Observable<Void>) -> Disposable {
        let location = Observable.combineLatest(title, region, country)
            .map { [unowned self] t, r, c in
                Location(
                    id: LocationID(),
                    name: t,
                    region: r,
                    country: c,
                    coordinate: self.coordinate,
                    timezoneIdentifier: nil
                )
            }
            .share(replay: 1)
        
        let confirmedLocation = tapped.withLatestFrom(location)
        let addAction = dependencies.locationsStore
            .add(confirmedLocation)
        let coordinatorAction = confirmedLocation
            .subscribe(onNext: { [weak self] in self?.coordinator?.select($0) })
        
        return Disposables.create {
            addAction.dispose()
            coordinatorAction.dispose()
        }
    }
    
    func geoCoding(requested: Observable<Void>) -> Disposable {
        Disposables.create()
    }
    
}
