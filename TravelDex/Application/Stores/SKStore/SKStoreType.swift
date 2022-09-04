//
//  SKStoreType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation
import StoreKit
import RxSwift



protocol SKStoreType {
    
    // MARK: - Input
    func purchase(product: Observable<Product>) async throws
    
    
    // MARK: - Output
    var products: Observable<[Product]> { get }
    var purchasedProducts: Observable<[Product]> { get }
    
}
