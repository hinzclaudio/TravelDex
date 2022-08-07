//
//  WeatherAPI.Location.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation



struct WeatherAPILocation: Codable {
    let id: Int
    let name: String
    let region: String?
    let country: String
    let lat: Double
    let lon: Double
    let queryParameter: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case region
        case country
        case lat
        case lon
        case queryParameter = "url"
    }
}
