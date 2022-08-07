//
//  Endpoint.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation



protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    func body(with encoder: JSONEncoder) throws -> Data?
    func queryItems() -> [URLQueryItem]?
}


extension Endpoint {
    func body(with encoder: JSONEncoder) throws -> Data? {
        nil
    }
    
    func queryItems() -> [URLQueryItem]? {
        nil
    }
    
}
