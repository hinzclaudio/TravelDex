//
//  Colors.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import CryptoSwift



struct Colors {
    static let veryDark = UIColor(hex: "00182d")!
    static let mediumDark = UIColor(hex: "4C5D6C")!
    static let defaultWhite = UIColor(hex: "ecf3f0")!
    static let darkGreen = UIColor(hex: "3d5f5d")!
    static let lightGreen = UIColor(hex: "ADC4BD")!
    static let orange = UIColor(hex: "fdb14d")!
    static let darkRed = UIColor(hex: "671d26")!
    static let black = UIColor(hex: "000000")!
    static let lightSandRose = UIColor(hex: "DCD8D9")!
    static let darkSandRose = UIColor(hex: "95888a")!
    
    static var navBarColor: UIColor { mediumDark }
}
        
        

extension UIColor {
    
    convenience init(
        lightColor: @escaping @autoclosure () -> UIColor,
        darkColor: @escaping @autoclosure () -> UIColor
     ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return lightColor()
            case .dark:
                return darkColor()
            @unknown default:
                return lightColor()
            }
        }
    }
    
    
    convenience init?(hex: String, alpha: CGFloat = 1) {
        let rawData = Array<UInt8>(hex: hex)
        guard rawData.count == 3 else { return nil }
        let r = CGFloat(rawData[0]) / 255
        let g = CGFloat(rawData[1]) / 255
        let b = CGFloat(rawData[2]) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
}



