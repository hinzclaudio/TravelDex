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
    
    var purchaseProductCalled = false
    func purchase(_ product: Product) async throws {
        purchaseProductCalled = true
    }
    
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
    
}
