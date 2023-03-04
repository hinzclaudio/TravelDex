//
//  PlaceDisplayViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 13.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit



class PlaceDisplayViewModel: LocationDisplayViewModelType {
    
    typealias Dependencies = HasPlacesStore
    private let dependencies: Dependencies
    private let visistedPlaceId: VisitedPlaceID
    
    init(dependencies: Dependencies, visitedPlaceId: VisitedPlaceID) {
        self.dependencies = dependencies
        self.visistedPlaceId = visitedPlaceId
    }
    
    
    private lazy var visitedPlace: Observable<AddedPlaceItem?> = {
        dependencies.placesStore
            .place(identifiedBy: .just(visistedPlaceId))
            .share(replay: 1, scope: .whileConnected)
    }()
    
    
    
    lazy var controllerTitle: Driver<String> = {
        visitedPlace
            .compactMap(\.?.visitedPlace.location.name)
            .asDriver(onErrorJustReturn: "")
    }()
    
    lazy var annotations: Driver<[MKAnnotation]> = {
        visitedPlace
            .compactMap { $0 }
            .map { item in [LocationDisplayAnnotation(for: item)] }
            .asDriver(onErrorJustReturn: [])
    }()
    
}
