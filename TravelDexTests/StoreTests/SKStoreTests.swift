//
//  SKStoreTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 07.09.22.
//

import Foundation
import StoreKit
import StoreKitTest
import RxBlocking
import RxSwift
import XCTest
@testable import TravelDex




class SKStoreTests: XCTestCase {
    
    enum SKStoreError: Error {
        case purchaseError
        case missingTransaction
        case syncError
    }
    
    var session: SKTestSession!
    var store: SKStoreType!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        store = SKStore()
        if session == nil {
            session = try SKTestSession(configurationFileNamed: "Configuration")
        }
        session.clearTransactions()
        session.resetToDefaultState()
        session.disableDialogs = true
    }
    
    func testProductsIsNonEmpty() throws {
        let products = try store.products
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(products)
        XCTAssertEqual(products?.count, 3)
    }
    
    func testPurchasesIsEmptyInitially() throws {
        XCTAssertThrowsError(
            try store.purchasedProducts
                .filter { !$0.isEmpty }
                .toBlocking(timeout: 5)
                .first()
        )
    }
    
    func testSimplePurchasedProductsIsUpdated() throws {
        let premium = try simplePremiumProduct()
        
        let expectation = XCTestExpectation(description: "Purchase: No Throw")
        Task {
            try await store.purchase(premium)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        let products = try store.purchasedProducts
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(products)
        XCTAssertEqual(products?.count, 1)
        XCTAssertEqual(products?.first?.id, premium.id)
    }
    
    func testAskToBuyPurchasedProductsIsNotUpdated() throws {
        session.askToBuyEnabled = true
        let premium = try simplePremiumProduct()
        let expectation = XCTestExpectation(description: "Purchase: No Throw")
        Task {
            try await store.purchase(premium)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertThrowsError(
            try store.purchasedProducts
                .filter { !$0.isEmpty }
                .toBlocking(timeout: 5)
                .first()
        )
    }
    
    func testAskToBuyConfirmPurchasedProductsIsUpdated() throws {
        session.askToBuyEnabled = true
        let premium = try simplePremiumProduct()
        let expectation = XCTestExpectation(description: "Purchase: No Throw")
        Task {
            try await store.purchase(premium)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        guard let transaction = session.allTransactions().first
        else { throw SKStoreError.missingTransaction }
        XCTAssertTrue(transaction.pendingAskToBuyConfirmation)
        
        try session.approveAskToBuyTransaction(identifier: transaction.identifier)
        
        let purchases = try store.purchasedProducts
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(purchases)
        XCTAssertEqual(purchases?.count, 1)
        XCTAssertEqual(purchases?.first?.id, premium.id)
    }
    
    func testRefundPurchasedProductsIsUpdated() throws {
        try testSimplePurchasedProductsIsUpdated()
        
        guard let transaction = session.allTransactions().first
        else { throw SKStoreError.missingTransaction }
        XCTAssertNil(transaction.expirationDate)
        
        try session.refundTransaction(identifier: transaction.identifier)
        
        let purchases = try store.purchasedProducts
            .filter { $0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(purchases)
        XCTAssertEqual(purchases?.count, 0)
    }
    
    func testPurchaseThrowsError() throws {
        session.failTransactionsEnabled = true
        let premium = try simplePremiumProduct()
        let expectation = XCTestExpectation(description: "Purchase: Throws")
        Task {
            do {
                try await store.purchase(premium)
            } catch {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testSyncDoesNotThrow() throws {
        let expectation = XCTestExpectation(description: "Sync: No Throw")
        Task {
            try await store.sync()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    
    
    // MARK: - Helper
    func simplePremiumProduct() throws -> Product {
        try store.products
            .compactMap { prods in
                prods.first(where: { $0.id == SKProductIDs.premium.rawValue })
            }
            .toBlocking(timeout: 5)
            .first()!
    }
    
    
    
    // MARK: - TearDown
    override func tearDownWithError() throws {
        session.resetToDefaultState()
        session.clearTransactions()
    }
    
}
