//
//  SFSymbols.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



enum SFSymbol: String {
    case plus
    case gear
    case pencil
    
    var image: UIImage {
        UIImage(systemName: rawValue)!
    }
}
