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
    
    func setStart(of item: AddedPlaceItem, to date: Date)
    func setEnd(of item: AddedPlaceItem, to date: Date)
    
    func set(_ item: AddedPlaceItem, expanded: Bool)
    func imageTapped(_ item: AddedPlaceItem, view: UIImageView)
    
    
    // MARK: - Output
    var trip: Driver<Trip> { get }
    var addedPlaces: Driver<[AddedPlaceSection]> { get }
    func menu(for item: AddedPlaceItem) -> UIMenu
    
    
    // MARK: - View State
    var loadingImagesFor: Driver<Set<VisitedPlaceID>> { get }
    
}
