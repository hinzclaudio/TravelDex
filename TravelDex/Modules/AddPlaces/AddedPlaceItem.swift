//
//  AddedPlaceItem.swift
//  TravelDex
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation
import RxDataSources



struct AddedPlaceItem: Equatable {
    let visitedPlace: VisitedPlace
    let pinColor: UIColor
}
