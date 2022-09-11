//
//  MockSKStore.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 07.09.22.
//

import Foundation
import RxSwift
import StoreKit
@testable import TravelDex



class MockSKStore: SKStoreType {
    
    // MARK: - Input
    var purchaseThrows = false
    var purchaseProductCalled = false
    func purchase(_ product: Product) async throws {
        purchaseProductCalled = true
        if purchaseThrows {
            throw SKStoreTests.SKStoreError.purchaseError
        }
    }
    
    var syncThrows = false
    var syncCalled = false
    func sync() async throws {
        syncCalled = true
        if syncThrows {
            throw SKStoreTests.SKStoreError.syncError
        }
    }
    
    
    
    // MARK: - Output
    var products: Observable<[Product]> {
        Observable.create { observer in
            let task = Task {
                do {
                    let products = try await Product.products(for: SKProductIDs.allCases.map(\.rawValue))
                    observer.onNext(products)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    var purchasedProducts: Observable<[Product]> {
        Observable.create { observer in
            observer.onNext([])
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    var enablePremium = false
    var premiumFeaturesEnabled: Observable<Bool> {
        Observable
            .just(enablePremium)
    }
    
}
