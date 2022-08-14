//
//  LocationSearchViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol LocationSearchViewModelType {
    
    // MARK: - Input
    func select(_ location: Observable<Location>) -> Disposable
    
    
    // MARK: - Output
    var isLoading: Driver<Bool> { get }
    var errorController: Driver<UIAlertController> { get }
    func searchResults(for query: Observable<String>) -> Driver<[Location]>
    
}
