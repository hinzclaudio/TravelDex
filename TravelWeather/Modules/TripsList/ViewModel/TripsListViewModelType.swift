//
//  TripsListViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol TripsListViewModelType {
    
    // MARK: - Input
    func addTapped(_ tap: Observable<Void>) -> Disposable
    
    
    // MARK: - Output
    func trips(for search: Observable<String>) -> Driver<[Trip]>
    
}
