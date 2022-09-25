//
//  VisitedPlaceExport.swift
//  TravelDex
//
//  Created by Claudio Hinz on 24.09.22.
//

import Foundation



struct VisitedPlaceExport: Codable {
    let id: VisitedPlaceID
    let text: String?
    let start: Date
    let end: Date
    let locationName: String
    let locationRegion: String?
    let locationCountry: String?
    let locationTimezone: String?
    let locationLatitude: Double
    let locationLongitude: Double
}
