//
//  SFSymbols.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



enum SFSymbol: String {
    case plus
    case plusCircle = "plus.circle"
    case gear
    case pencil
    case trash
    case emptyImage = "doc.text.image"
    case calendar
    case map
    case camera
    case filledMappin = "pin.fill"
    
    var image: UIImage {
        UIImage(systemName: rawValue)!
    }
}
