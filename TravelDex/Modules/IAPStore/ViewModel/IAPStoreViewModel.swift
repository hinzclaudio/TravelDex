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
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    lazy var products: Driver<[Product]> = {
        dependencies.skStore.products
            .asDriver(onErrorJustReturn: [])
    }()
    
    
    
}
