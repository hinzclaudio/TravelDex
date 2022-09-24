//
//  VisitedPlaceExport.swift
//  TravelDex
//
//  Created by Claudio Hinz on 24.09.22.
//

import Foundation



struct VisitedPlaceExport: Codable {
    let text: String?
    let start: Date
    let end: Date
    /// The export file is a zip file. If any jpg data is available, this is the relative path where the data can be found.
    let picturePath: String?
    let locationName: String
    let locationRegion: String?
    let locationCountry: String?
    let locationTimezone: String?
    let locationLatitude: Double
    let locationLongitude: Double
}
