//
//  TripsListViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol TripsListViewModelType: UIDocumentPickerDelegate {
    
    // MARK: - Input
    var storeTapped: PublishRelay<Void> { get }
    var mapTapped: PublishRelay<Void> { get }
    var addTapped: PublishRelay<Void> { get }
    var importTapped: PublishRelay<Void> { get }
    
    var exportTrip: PublishRelay<Trip> { get }
    var shareTrip: PublishRelay<Trip> { get }
    var selectTrip: PublishRelay<Trip> { get }
    var deleteTrip: PublishRelay<Trip> { get }
    var editTrip: PublishRelay<Trip> { get }
    var pickColorForTrip: PublishRelay<Trip> { get }
    
    func onDidLoad()
    
    
    // MARK: - Output
    func trips(for search: Observable<String>) -> Driver<[Trip]>
    var tripsIsEmpty: Driver<Bool> { get }
    var errorController: Driver<UIAlertController> { get }
    
}
