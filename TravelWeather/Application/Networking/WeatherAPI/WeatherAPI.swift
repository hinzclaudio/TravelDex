//
//  WeatherAPI.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 07.08.22.
//

import Foundation
import RxSwift
import Keys



class WeatherAPI: WeatherAPIType {
    
    private let keys = TravelWeatherKeys()
    private let baseURL = "https://api.weatherapi.com/v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    
    
    private func build(_ endpoint: Endpoint) -> Observable<Data> {
        let url = URL(string: baseURL + endpoint.path)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = (endpoint.queryItems() ?? []) + defaultQueryItems()
        
        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endpoint.method.rawValue
        do {
            request.httpBody = try endpoint.body(with: encoder)
        } catch {
            assertionFailure("WeatherAPI: Failed to make body \(error)")
        }
        
        return URLSession.shared.rx.data(request: request)
            .debug("WeatherAPI \(type(of: endpoint))")
    }
    
    
    private func buildAndMap<T: Decodable>(endpoint: Endpoint) -> Observable<T> {
        build(endpoint)
            .compactMap { [weak self] in try self?.decoder.decode(T.self, from: $0) }
    }
    
    
    func searchLocations(_ query: String) -> Observable<[WeatherAPILocation]> {
        buildAndMap(endpoint: Search(searchQuery: query))
    }
    
    
    
    // MARK: - Query Items
    private func defaultQueryItems() -> [URLQueryItem] {
        [
            authorizationQueryItem(),
            langQueryItem()
        ]
    }
    
    private func authorizationQueryItem() -> URLQueryItem {
        let weatherKey = keys.weatherAPIKey
        return URLQueryItem(name: "key", value: weatherKey)
    }
    
    private func langQueryItem() -> URLQueryItem {
        let langKey = NSLocale.autoupdatingCurrent.languageCode ?? "en"
        return URLQueryItem(name: "lang", value: langKey)
    }
    
    
}
