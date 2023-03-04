//
//  AddPlacesCommentViewModelTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 24.08.22.
//

import Foundation
import XCTest
import RxSwift
import RxBlocking
@testable import TravelDex



class AddPlacesCommentViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var mockCoordinator: MockAppCoordinator!
    var viewModel: AddPlacesCommentViewModelType!
    
    let somePlace = VisitedPlace(
        id: VisitedPlaceID(),
        start: .now.addingTimeInterval(-86400),
        end: .now,
        tripId: TripID(),
        location: MockLocationAPI.hamburg
    )
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.mockCoordinator = MockAppCoordinator()
        self.viewModel = AddPlacesCommentViewModel(
            dependencies: mockDependencies,
            item: AddedPlaceItem(
                visitedPlace: somePlace,
                pinColor: Trip.defaultPinColor
            ),
            coordinator: mockCoordinator
        )
    }
    
    
    func testPlaceIsUpdatedByStore() throws {
        let place = try viewModel.addedPlace
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(place)
        XCTAssertTrue(mockDependencies.mockPlacesStore.placeIdentifiedByCalled)
    }
    
    func testConfirmCoordinatorIsNotified() throws {
        XCTAssertFalse(mockCoordinator.dismissModalControllerCalled)
        let _ = viewModel.confirm(.just(()))
        XCTAssertTrue(mockCoordinator.dismissModalControllerCalled)
    }
    
}
