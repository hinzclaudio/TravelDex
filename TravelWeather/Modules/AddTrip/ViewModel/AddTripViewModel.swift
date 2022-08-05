//
//  AddTripViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



class AddTripViewModel: AddTripViewModelType {
    
    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
}
