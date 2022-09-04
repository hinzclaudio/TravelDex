//
//  IAPStoreViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa



protocol IAPStoreViewModelType {
    
    var products: Driver<[Product]> { get }
    
}
