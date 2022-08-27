//
//  LocationEntryViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 27.08.22.
//

import Foundation
import RxSwift




class LocationEntryViewModel: LocationEntryViewModelType {
    
    typealias Dependencies = HasLocationsStore
    private let dependencies: Dependencies
    private let coordinate: Coordinate
    
    init(dependencies: Dependencies, coordinate: Coordinate) {
        self.dependencies = dependencies
        self.coordinate = coordinate
    }
    
}
