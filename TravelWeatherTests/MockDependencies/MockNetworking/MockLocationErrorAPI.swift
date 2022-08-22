//
//  MockLocationErrorAPI.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxSwift
@testable import TravelWeather



class MockLocationErrorAPI: LocationAPIType {
    
    enum MockError: Error {
        case mockedErrorCase
    }
    
    // MARK: - Instance
    func getLocations(search: String) -> Observable<[Location]> {
        Observable.create { observer in
            observer.onError(MockError.mockedErrorCase)
            return Disposables.create()
        }
    }
    
}
