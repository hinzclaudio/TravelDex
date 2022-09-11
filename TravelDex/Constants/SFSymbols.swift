//
//  SFSymbols.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



enum SFSymbol: String {
    case plus
    case plusCircle = "plus.circle"
    case gear
    case pencil
    case paintpalette
    case squareAndPencil = "square.and.pencil"
    case trash
    case emptyImage = "doc.text.image"
    case calendar
    case map
    case camera
    case cart
    case filledMappin = "pin.fill"
    case infoCircle = "info.circle"
    
    var image: UIImage {
        UIImage(systemName: rawValue)!
    }
}
