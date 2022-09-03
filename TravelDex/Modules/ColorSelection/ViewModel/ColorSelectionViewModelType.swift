//
//  ColorSelectionViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 28.08.22.
//

import UIKit
import RxSwift
import RxCocoa



protocol ColorSelectionViewModelType {
    
    var trip: Driver<Trip> { get }
    var availableColors: Driver<[UIColor]> { get }
    func select(_ color: Observable<UIColor>) -> Disposable
    
}
