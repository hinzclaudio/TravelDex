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
    func mapTapped(_ tap: Observable<Void>) -> Disposable
    func addTapped(_ tap: Observable<Void>) -> Disposable
    func select(_ trip: Observable<Trip>) -> Disposable
    func delete(_ trip: Observable<Trip>) -> Disposable
    func edit(_ trip: Observable<Trip>) -> Disposable
    
    
    // MARK: - Output
    func trips(for search: Observable<String>) -> Driver<[Trip]>
    func preview(for trip: Trip) -> UIViewController?
    
}
