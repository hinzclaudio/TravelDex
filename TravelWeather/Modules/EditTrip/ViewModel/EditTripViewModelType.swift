//
//  EditTripViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



protocol EditTripViewModelType {
    func update(_ trip: Observable<Trip>) -> Disposable
}
