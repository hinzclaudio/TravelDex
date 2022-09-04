//
//  SKStore.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa



class SKStore: SKStoreType {
    
    init() {
        self.products = _products.asObservable()
        self.purchasedProducts = _purchasedProducts
            .scan(into: []) { purchasedSoFar, product in purchasedSoFar.append(product) }
        
        Task {
            await requestProducts()
            updatePurchases()
        }
    }
    
    private let bag = DisposeBag()
    
    
    
    // MARK: - Output
    private let _products = BehaviorRelay<[Product]>(value: [])
    let products: Observable<[Product]>
    
    private let _purchasedProducts = PublishSubject<Product>()
    let purchasedProducts: Observable<[Product]>

    
    
    // MARK: - Private Implementation
    private func requestProducts() async {
        do {
            let availableProducts = try await Product.products(for: SKProductIDs.allCases.map(\.rawValue))
            _products.accept(availableProducts)
        } catch {
            assertionFailure("Something's wrong: \(error)")
        }
    }
    
    private func updatePurchases() {
        StoreKit.Transaction.currentEntitlements.asObservable()
            .compactMap { $0.isVerified() }
            .withLatestFrom(products) { t, prods in prods.first(where: { $0.id == t.productID }) }
            .compactMap { $0 }
            .bind(to: _purchasedProducts)
            .disposed(by: bag)
    }
    
}
