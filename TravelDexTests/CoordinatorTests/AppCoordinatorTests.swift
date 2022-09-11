//
//  AppCoordinatorTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 11.09.22.
//

import UIKit
import XCTest
@testable import TravelDex



class AppCoordinatorTests: XCTestCase {
    
    var dependencies: MockDependencies!
    var coordinator: AppCoordinatorType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.dependencies = MockDependencies()
        self.coordinator = AppCoordinator(window: nil, dependencies: dependencies)
    }
    
    
    func testColorSelectionDisabledForNonPremiumUsers() throws {
        // TODO: Implement
    }
    
    func testColorSelectionEnabledForPremiumUsers() throws {
        // TODO: Implement
    }
    
}
