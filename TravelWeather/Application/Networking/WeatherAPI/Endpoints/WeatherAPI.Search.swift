//
//  WeatherAPI.Endpoint.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation



extension WeatherAPI {
    
    struct Search: Endpoint {
        let path = "/search.json"
        let method = HTTPMethod.get
        let searchQuery: String
        
        func queryItems() -> [URLQueryItem]? {
            [URLQueryItem(name: "q", value: searchQuery)]
        }
    }
    
}

