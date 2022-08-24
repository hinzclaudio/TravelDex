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
    
    weak var coorindator: AppCoordinator?
    private let selection: (Location) -> Void
    
    typealias Dependencies = HasLocationsStore & HasPlacesStore
    private let dependencies: Dependencies
    
    
    init(dependencies: Dependencies, selection: @escaping (Location) -> Void) {
        self.dependencies = dependencies
        self.selection = selection
    }
    
    
    
    // MARK: - Input
    
    
    // MARK: - Output
    
    
}
