//
//  CustomLocationEntryViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class CustomLocationEntryViewModel: CustomLocationEntryViewModelType {
    
    typealias Dependencies = HasLocationsStore & HasPlacesStore
    private let dependencies: Dependencies
    private let selection: () -> Location
    
    init(dependencies: Dependencies, selection: @escaping () -> Location) {
        self.dependencies = dependencies
        self.selection = selection
    }
    
    
    
    // MARK: - Input
    
    
    // MARK: - Output
    
    
}
