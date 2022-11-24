//
//  PremiumStoreViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa



protocol PremiumStoreViewModelType {
    
    // MARK: - Input
    func purchase(product: Observable<Product>) -> Disposable
    func info(_ tapped: Observable<Void>) -> Disposable
    func restorePurchases()
    
    
    // MARK: - Output
    var isPurchasing: Driver<Bool> { get }
    var products: Driver<[PremiumProduct]> { get }
    var errorAlert: Driver<UIAlertController> { get }
    
}
