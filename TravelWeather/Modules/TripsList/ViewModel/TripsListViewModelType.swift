//
//  TripsListViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



protocol TripsListViewModelType {
    
    // MARK: - Input
    func addTapped(_ tap: Observable<Void>) -> Disposable
    
    
    // MARK: - Output
    
}
