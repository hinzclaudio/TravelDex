//
//  Trip.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



struct Trip: Equatable {
    let id: UUID
    let title: String
    let description: String?
    let visitedLocations: [VisitedPlace]
}
