//
//  IAPStoreViewModelTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 07.09.22.
//

import Foundation
import XCTest
@testable import TravelDex
import SwiftUI



class IAPStoreViewModelTests: XCTestCase {
    
    
    var mockDependencies: MockDependencies!
    var viewModel: IAPStoreViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = IAPStoreViewModel(dependencies: mockDependencies)
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
    
    
    
    // MARK: - Helpers
    func anyProduct(purchased: Bool = false) throws -> IAPProduct {
        try viewModel.products
            .compactMap { prods in prods.first(where: { $0.isPurchased == purchased }) }
            .toBlocking(timeout: 5)
            .first()!
    }
    
    
}
