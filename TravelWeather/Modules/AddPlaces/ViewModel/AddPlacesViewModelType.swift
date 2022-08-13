//
//  AddPlacesViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol AddPlacesViewModelType {
    
    // MARK: - Input
    func mapButton(_ tapped: Observable<Void>) -> Disposable
    func addLocation(_ tapped: Observable<Void>) -> Disposable
    func set(_ item: AddedPlaceItem, expanded: Bool)
    func setStart(of item: AddedPlaceItem, to date: Date)
    func setEnd(of item: AddedPlaceItem, to date: Date)
    
    
    // MARK: - Output
    var trip: Driver<Trip> { get }
    var addedPlaces: Driver<[AddedPlaceItem]> { get }
    var expandedItems: Driver<Set<VisitedPlaceID>> { get }
    
    func menu(for item: AddedPlaceItem) -> UIMenu
    
}
