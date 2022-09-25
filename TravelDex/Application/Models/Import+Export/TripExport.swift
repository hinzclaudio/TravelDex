//
//  TripExport.swift
//  TravelDex
//
//  Created by Claudio Hinz on 24.09.22.
//

import Foundation



struct TripExport: Codable {
    let id: TripID
    let title: String
    let descr: String?
    let members: String?
    let places: [VisitedPlaceExport]
}
