//
//  WeatherAPIType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation
import RxSwift



protocol WeatherAPIType {
    
    func searchLocations(_ query: String) -> Observable<[WeatherAPILocation]>
    
}
