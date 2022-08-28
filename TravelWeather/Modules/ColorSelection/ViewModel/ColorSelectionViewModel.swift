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
    
    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
}
