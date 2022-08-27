//
//  LocationEntryViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 27.08.22.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa



protocol LocationEntryViewModelType {
    
    var title: BehaviorRelay<String> { get }
    var region: BehaviorRelay<String?> { get }
    var country: BehaviorRelay<String?> { get }
    var snapshot: Driver<UIImage?> { get }
    
    func confirm(_ tapped: Observable<Void>) -> Disposable
    
}
