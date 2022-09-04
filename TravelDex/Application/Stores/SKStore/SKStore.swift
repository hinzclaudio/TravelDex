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
        self.purchasedProducts = _purchasedProducts.asObservable()
        self.updateListener = listenForTransactions()
        Task {
            await requestProducts()
            updatePurchases()
        }
    }
    
    private var updateListener: Task<Void, Error>?
    private let bag = DisposeBag()
    
    
    // MARK: - Input
    func purchase(product: Observable<Product>) async throws {
        for try await p in product.values {
            let result = try await p.purchase()
            switch result {
            case .success(let verification):
                let transaction = verification.isVerified()
                updatePurchases()
                await transaction?.finish()
            default:
                break
            }
        }
    }
    
    
    // MARK: - Output
    private let _products = BehaviorRelay<[Product]>(value: [])
    let products: Observable<[Product]>
    
    private let _purchasedProducts = BehaviorRelay<[Product]>(value: [])
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
            .scan(into: [], accumulator: { $0.append($1) })
            .bind(to: _purchasedProducts)
            .disposed(by: bag)
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let transaction = result.isVerified() else { continue }
                self?.updatePurchases()
                await transaction.finish()
            }
        }
    }
    
    deinit {
        updateListener?.cancel()
    }
    
}
