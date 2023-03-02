//
//  LocationEntryViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 27.08.22.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import MapKit



class LocationEntryViewModel: LocationEntryViewModelType {
    
    weak var coordinator: LocationSearchCoordinator?
    
    typealias Dependencies = HasLocationsStore
    private let dependencies: Dependencies
    private let coordinate: Coordinate
    private let bag = DisposeBag()
    
    
    init(dependencies: Dependencies, coordinate: Coordinate) {
        self.dependencies = dependencies
        self.coordinate = coordinate
        
        let location = self.dependencies.locationsStore.location(for: .just(coordinate))
            .share(replay: 1)
        
        location
            .map { $0.name }
            .bind(to: title)
            .disposed(by: bag)
        location
            .map { $0.region }
            .bind(to: region)
            .disposed(by: bag)
        location
            .map { $0.country }
            .bind(to: country)
            .disposed(by: bag)
    }
    
    
    let title = BehaviorRelay(value: "")
    let region = BehaviorRelay<String?>(value: nil)
    let country = BehaviorRelay<String?>(value: nil)
    
    
    lazy var snapshot: Driver<UIImage?> = {
        let wSpan: Double = 0.01
        let wSize = Double(UIScreen.main.bounds.size.width - 2 * Sizes.defaultMargin)
        let vSize = Sizes.defaultSnapshotHeight
        let vSpan = (wSpan / wSize) * vSize
        
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: wSize, height: vSize)
        options.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: wSpan,
                longitudeDelta: vSpan
            )
        )
        let snapshotter = MKMapSnapshotter(options: options)
        return snapshotter.snapshot
            .asDriver(onErrorJustReturn: nil)
    }()
    
    func confirm(_ tapped: Observable<Void>) -> Disposable {
        let location = Observable.combineLatest(title, region, country)
            .map { [unowned self] t, r, c in
                Location(
                    name: t,
                    region: r,
                    country: c,
                    coordinate: self.coordinate
                )
            }
            .share(replay: 1)
        
        let confirmedLocation = tapped.withLatestFrom(location)
        return confirmedLocation
            .subscribe(onNext: { [weak self] in self?.coordinator?.select($0) })
    }
    
}
