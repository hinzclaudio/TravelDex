//
//  TripsListViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol TripsListViewModelType {
    
    // MARK: - Input
    func storeTapped(_ tap: Observable<Void>) -> Disposable
    func mapTapped(_ tap: Observable<Void>) -> Disposable
    func addTapped(_ tap: Observable<Void>) -> Disposable
    func importTapped(_ tap: Observable<Void>) -> Disposable
    func select(_ trip: Observable<Trip>) -> Disposable
    func delete(_ trip: Observable<Trip>) -> Disposable
    func edit(_ trip: Observable<Trip>) -> Disposable
    func pickColor(for trip: Observable<Trip>) -> Disposable
    
    
    // MARK: - Output
    var tripsIsEmpty: Driver<Bool> { get }
    func trips(for search: Observable<String>) -> Driver<[Trip]>
    
    
    
}
