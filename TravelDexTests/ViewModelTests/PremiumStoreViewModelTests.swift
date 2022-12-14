//
//  PremiumStoreViewModelTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 07.09.22.
//

import Foundation
import XCTest
@testable import TravelDex



class PremiumStoreViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: PremiumStoreViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = PremiumStoreViewModel(dependencies: mockDependencies)
    }
    
    
    func testProductsIsNonEmptyInitially() throws {
        let products = try viewModel.products
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(products)
        XCTAssertEqual(products?.count ?? 0, 3)
        XCTAssertEqual(products?.filter { $0.isPurchased }.count, 0)
    }
    
    func testErrorIsEmptyInitially()  throws {
        XCTAssertThrowsError(
            try viewModel.errorAlert
                .toBlocking(timeout: 5)
                .first()
        )
    }
    
    func testPurchaseProductIsRelayedToStore() throws {
        let product = try anyProduct().product
        let _ = viewModel.purchase(product: .just(product))
        
        // Wait some time for the purchase to happen...
        let _ = try viewModel.products
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertTrue(mockDependencies.mockSkStore.purchaseProductCalled)
    }
    
    func testPurchaseThrowsIsRelayed() throws {
        mockDependencies.mockSkStore.purchaseThrows = true
        let product = try anyProduct().product
        let _ = viewModel.purchase(product: .just(product))
        
        let errorAlert = try viewModel.errorAlert
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(errorAlert)
    }
    
    func testSyncIsRelayedToStore() throws {
        viewModel.restorePurchases()
        
        // Wait some time for the purchase to happen...
        let _ = try viewModel.products
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertTrue(mockDependencies.mockSkStore.syncCalled)
    }
    
    func testSyncErrorIsRelayed() throws {
        mockDependencies.mockSkStore.syncThrows = true
        viewModel.restorePurchases()
        
        let errorAlert = try viewModel.errorAlert
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(errorAlert)
    }
    
    func testIsPurchasingFalseInitially() throws {
        let initialValue = try viewModel.isPurchasing
            .toBlocking(timeout: 5)
            .first()
        XCTAssertEqual(initialValue, false)
    }
    
    func testIsPurchasingTrueWhilePurchasing() throws {
        let product = try anyProduct()
        let _ = viewModel
            .purchase(product: .just(product.product))
        let isPurchasing = try viewModel.isPurchasing
            .filter { $0 == true }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertEqual(isPurchasing, true)
    }
    
    func testIsPurchasingFalseAfterSuccessfullPurchase() throws {
        mockDependencies.mockSkStore.purchaseThrows = false
        let product = try anyProduct()
        let _ = viewModel
            .purchase(product: .just(product.product))
        
        // Wait for the purchase to happen.
        let _ = try anyProduct()
        
        let isPurchasing = try viewModel.isPurchasing
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertEqual(isPurchasing, false)
    }
    
    func testIsPurchasingFalseAfterFailedPurchase() throws {
        mockDependencies.mockSkStore.purchaseThrows = true
        let product = try anyProduct()
        let _ = viewModel
            .purchase(product: .just(product.product))
        
        // Wait for the purchase to happen.
        let _ = try anyProduct()
        
        let isPurchasing = try viewModel.isPurchasing
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertEqual(isPurchasing, false)
    }
    
    
    
    // MARK: - Helpers
    func anyProduct() throws -> PremiumProduct {
        try viewModel.products
            .compactMap { prods in prods.first }
            .toBlocking(timeout: 10)
            .first()!
    }
    
    
}
