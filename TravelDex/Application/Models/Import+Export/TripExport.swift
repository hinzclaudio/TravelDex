//
//  TripExport.swift
//  TravelDex
//
//  Created by Claudio Hinz on 24.09.22.
//

import Foundation



struct TripExport: Codable {
    let title: String
    let descr: String?
    let members: String?
    /// The export file is a zip file. If any jpg data is available, this is the relative path where the data can be found.
    let picturePath: String?
    let places: [VisitedPlaceExport]
}
