//
//  LocationSearchViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol LocationSearchViewModelType {
    
    func searchResults(for query: Observable<String>) -> Driver<[Location]>
    
}
