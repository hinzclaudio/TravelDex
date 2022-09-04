//
//  Colors.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import CryptoSwift



struct Colors {
    static let veryDark = UIColor(hex: "00182d")!
    static let mediumDark = UIColor(hex: "37434E")!
    static let defaultWhite = UIColor(hex: "ecf3f0")!
    static let darkGreen = UIColor(hex: "3d5f5d")!
    static let lightGreen = UIColor(hex: "ADC4BD")!
    static let darkRed = UIColor(hex: "671d26")!
    static let black = UIColor(hex: "000000")!
    static let lightSandRose = UIColor(hex: "DCD8D9")!
    static let darkSandRose = UIColor(hex: "95888a")!
    static let gray = UIColor.gray
    
    static var navBarColor: UIColor { mediumDark }
    
    static var pickerColors: [UIColor] {
        [
            UIColor(hex: "2e521d")!, UIColor(hex: "4D8B31")!, UIColor(hex: "6ebf49")!,
            UIColor(hex: "dd1e19")!, Trip.defaultPinColor, UIColor(hex: "f49d9b")!,
            UIColor(hex: "f4a304")!, UIColor(hex: "FCBF49")!, UIColor(hex: "fdd994")!,
            UIColor(hex: "668148")!, UIColor(hex: "8CAC6A")!, UIColor(hex: "b2c79b")!,
            UIColor(hex: "105850")!, UIColor(hex: "1B998B")!, UIColor(hex: "28d9c5")!,
            UIColor(hex: "024d5d")!, UIColor(hex: "048BA8")!, UIColor(hex: "06c9f3")!,
            UIColor(hex: "3d455f")!, UIColor(hex: "5B678D")!, UIColor(hex: "858fb0")!,
            UIColor(hex: "612159")!, UIColor(hex: "9A348E")!, UIColor(hex: "c655b8")!,
            UIColor(hex: "191528")!, UIColor(hex: "392F5A")!, UIColor(hex: "59498c")!,
        ]
    }

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



