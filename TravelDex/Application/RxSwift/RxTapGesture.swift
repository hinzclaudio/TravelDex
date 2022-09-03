//
//  RxTapGesture.swift
//  TravelDex
//
//  Created by Claudio Hinz on 07.08.22.
//

import UIKit
import RxSwift
import RxCocoa



extension Reactive where Base == UITapGestureRecognizer {
    
    var tap: Observable<Void> {
        event
            .filter { $0.state == .ended }
            .map { _ in () }
    }
    
}
