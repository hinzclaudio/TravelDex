//
//  AddTripViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



protocol AddTripViewModelType {
    func add(_ trip: Observable<Trip>) -> Disposable
}
