//
//  AddedPlaceItem.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation
import RxDataSources



struct AddedPlaceItem: Equatable {
    let visitedPlace: VisitedPlace
    let location: Location
    let pinColor: UIColor
}
