//
//  AppCoordinatorType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.09.22.
//

import UIKit
import RxSwift



protocol AppCoordinatorType: CoordinatorType {
    
    func selectStore()
    func comment(on item: AddedPlaceItem)
    
    func handle(importForFileAt url: URL, inPlace: Bool) -> Disposable
    func dismissModalController()
    
    func pickPhoto(_ viewModel: PhotoPickerViewModelType, for visitedPlace: VisitedPlace)
    func photoViewer(from view: UIImageView?, image: UIImage?)
    
    func goToAddTrip(when tapped: Observable<Void>) -> Disposable
    func goToImportTrip(_ viewModel: TripsListViewModelType, when tapped: Observable<Void>) -> Disposable
    func share(exportAt url: Observable<URL>) -> Disposable
    func didUpdate(_ trip: Trip)
    func select(_ trip: Trip)
    func edit(_ trip: Trip)
    
    func pickColor(for trip: Observable<Trip>) -> Disposable
    func searchLocation(for trip: Observable<Trip>) -> Disposable
    
    func displayMap(for trip: Trip)
    func displayMap(for visitedPlace: VisitedPlace)
    func displayMap()
    
}
