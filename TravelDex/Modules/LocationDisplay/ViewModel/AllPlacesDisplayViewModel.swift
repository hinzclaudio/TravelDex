//
//  AllPlacesDisplayViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 13.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit



class AllPlacesDisplayViewModel: LocationDisplayViewModelType {
    
    typealias Dependencies = HasPlacesStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    
    lazy var controllerTitle: Driver<String> = {
        .just(Localizable.visistedPlaceTitle)
    }()
    
    lazy var annotations: Driver<[MKAnnotation]> = {
        dependencies.placesStore.allPlaces()
            .map { places in places.map { LocationDisplayAnnotation(for: $0) } }
            .asDriver(onErrorJustReturn: [])
    }()
    
}
