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
    
    // MARK: - Input
    func purchase(product: Observable<Product>) -> Disposable
    func restorePurchases()
    
    
    // MARK: - Output
    var products: Driver<[IAPProduct]> { get }
    var errorAlert: Driver<UIAlertController> { get }
    
}
