//
//  ShareOverviewViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.03.23.
//

import Foundation
import RxSwift
import RxCocoa



class ShareOverviewViewModel: ShareOverviewViewModelType {
    
    private weak var coordinator: ShareCoordinator?
    
    typealias Dependencies = HasCKStore & HasTripsStore
    private let dependencies: Dependencies
    private let bag = DisposeBag()
    
    private let tripId: TripID
    
    init(dependencies: Dependencies, coordinator: ShareCoordinator, tripId: TripID) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        self.tripId = tripId
    }
    
    
    public func onDidLoad() {
        
    }
    
}
