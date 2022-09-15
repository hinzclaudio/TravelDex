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
            await updatePurchases()
        }
    }
    
    private var updateListener: Task<Void, Error>?
    private let bag = DisposeBag()
    
    
    // MARK: - Input
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = verification.isVerified()
            await updatePurchases()
            await transaction?.finish()
        case .pending:
            print("SKStore: result pending")
        case .userCancelled:
            print("SKStore: cancelled")
        @unknown default:
            print("SKStore: unkown event")
        }
    }
    
    func sync() async throws {
        try await AppStore.sync()
        await updatePurchases()
    }
    
    
    // MARK: - Output
    private let _products = BehaviorRelay<[Product]>(value: [])
    let products: Observable<[Product]>
    
    private let _purchasedProducts = BehaviorRelay<[Product]>(value: [])
    let purchasedProducts: Observable<[Product]>
    
    var premiumFeaturesEnabled: Observable<Bool> {
        // Check if the purchases array contains a type of premium non-consumable
        // purchasedProducts
        //   .map { purchases in
        //        !purchases
        //            .filter { purchase in SKProductIDs.allPremiumIds.contains(purchase.id) }
        //            .isEmpty
        //    }
        .just(true)
    }

    
    
    // MARK: - Private Implementation
    private func requestProducts() async {
        do {
            let availableProducts = try await Product.products(for: SKProductIDs.allCases.map(\.rawValue))
            _products.accept(availableProducts)
        } catch {
            assertionFailure("Something's wrong: \(error)")
        }
    }
    
    private func updatePurchases() async {
        var newPurchases = [Product]()
        for await result in StoreKit.Transaction.currentEntitlements {
            guard let transaction = result.isVerified(),
                  let product = _products.value
                .first(where: { $0.id == transaction.productID })
            else { continue }
            newPurchases.append(product)
        }
        _purchasedProducts.accept(newPurchases)
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in StoreKit.Transaction.updates {
                guard let transaction = result.isVerified() else { continue }
                await self?.updatePurchases()
                await transaction.finish()
            }
        }
    }
    
    deinit {
        updateListener?.cancel()
    }
    
}
