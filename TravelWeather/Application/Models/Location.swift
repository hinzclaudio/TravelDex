//
//  Location.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



struct Location: Equatable {
    let name: String
    let region: String?
    let country: String
    let timezone: String
    let coordinate: Coordinate
}
