//
//  IAPStoreViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa



class IAPStoreViewModel: IAPStoreViewModelType {
    
    typealias Dependencies = HasSKStore
    private let dependencies: Dependencies
    weak var coordinator: AppCoordinator?
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func purchase(product: Observable<Product>) {
        Task {
            do {
                try await dependencies.skStore.purchase(product: product)
            } catch {
                print("Error")
            }
        }
    }
    
    
    lazy var products: Driver<[IAPProduct]> = {
        Observable.combineLatest(
            dependencies.skStore.products,
            dependencies.skStore.purchasedProducts
        )
        .map { availableProds, purchasedProds -> [IAPProduct] in
            availableProds
                .map { prod in
                    let isPurchased = purchasedProds.contains(where: { $0.id == prod.id })
                    return IAPProduct(product: prod, isPurchased: isPurchased)
                }
        }
        .asDriver(onErrorJustReturn: [])
    }()
    
    
    
}
