//
//  PremiumStoreViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa



class PremiumStoreViewModel: PremiumStoreViewModelType {
    
    typealias Dependencies = HasSKStore
    private let dependencies: Dependencies
    weak var coordinator: PremiumStoreCoordinator?
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    
    // MARK: - Input
    func purchase(product: Observable<Product>) -> Disposable {
        product.subscribe(
            onNext: { [unowned self] product in
                guard !self._isPurchasing.value else { return }
                Task {
                    await MainActor.run { self._isPurchasing.accept(true) }
                    do {
                        try await self.dependencies.skStore.purchase(product)
                    } catch {
                        self.skError.accept(error)
                    }
                    await MainActor.run { self._isPurchasing.accept(false) }
                }
            }
        )
    }
    
    func info(_ tapped: Observable<Void>) -> Disposable {
        tapped
            .subscribe(onNext: { [weak self] in self?.coordinator?.displayInfo() })
    }
    
    func restorePurchases() {
        Task {
            do {
                try await dependencies.skStore.sync()
            } catch {
                self.skError.accept(error)
            }
        }
    }
    
    
    
    // MARK: - Output
    private let _isPurchasing = BehaviorRelay(value: false)
    var isPurchasing: Driver<Bool> {
        _isPurchasing.asDriver()
    }
    
    lazy var products: Driver<[PremiumProduct]> = {
        Observable.combineLatest(
            dependencies.skStore.products,
            dependencies.skStore.purchasedProducts
        )
        .map { availableProds, purchasedProds -> [PremiumProduct] in
            availableProds
                .map { prod in
                    let isPurchased = purchasedProds.contains(where: { $0.id == prod.id })
                    return PremiumProduct(product: prod, isPurchased: isPurchased)
                }
        }
        .asDriver(onErrorJustReturn: [])
    }()
    
    private let skError = BehaviorRelay<Error?>(value: nil)
    lazy var errorAlert: Driver<UIAlertController> = {
        skError
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .map { error in InfoManager.defaultErrorInfo(for: error) }
    }()
    
}
