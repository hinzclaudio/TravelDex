//
//  LocationSearchViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit


protocol LocationSearchViewModelType {
    
    // MARK: - Input
    func select(_ location: Observable<Location>) -> Disposable
    func longPress(_ coordinate: Observable<Coordinate>) -> Disposable
    
    
    // MARK: - Output
    var errorController: Driver<UIAlertController> { get }
    func annotations(for query: Observable<String>) -> Driver<[MKAnnotation]>
    
}
