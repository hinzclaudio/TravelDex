//
//  AddPlacesCommentViewModelTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 24.08.22.
//

import Foundation
import XCTest
import RxSwift
import RxBlocking
@testable import TravelWeather



class AddPlacesCommentViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: AddPlacesCommentViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = AddPlacesCommentViewModel(
            dependencies: mockDependencies,
            item: AddedPlaceItem(
                visitedPlace: VisitedPlace(
                    id: VisitedPlaceID(),
                    start: .now.addingTimeInterval(-86400),
                    end: .now,
                    tripId: TripID(),
                    locationId: MockLocationAPI.hamburg.id
                ),
                location: MockLocationAPI
                    .hamburg,
                pinColor: Trip
                    .defaultPinColor
            )
        )
    }
    
    
    func testPlaceIsUpdatedByStore() throws {
        let place = try viewModel.addedPlace
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(place)
        XCTAssertTrue(mockDependencies.mockPlacesStore.placeIdentifiedByCalled)
    }
    
}
