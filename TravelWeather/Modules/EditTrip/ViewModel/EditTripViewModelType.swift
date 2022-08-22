//
//  EditTripViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol EditTripViewModelType {
    
    // MARK: - Input
    func update(_ trip: Observable<Trip>) -> Disposable
    
    
    // MARK: - Output
    var trip: Driver<Trip?> { get }
    var confirmButtonTitle: Driver<String> { get }
    
}
