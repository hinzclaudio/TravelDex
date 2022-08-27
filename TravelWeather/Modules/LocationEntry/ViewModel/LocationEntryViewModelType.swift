//
//  LocationEntryViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 27.08.22.
//

import Foundation
import RxSwift
import RxRelay



protocol LocationEntryViewModelType {
    
    var title: BehaviorRelay<String> { get }
    var region: BehaviorRelay<String?> { get }
    var country: BehaviorRelay<String?> { get }
    
    func confirm(_ tapped: Observable<Void>) -> Disposable
    func geoCoding(requested: Observable<Void>) -> Disposable
    
}
