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
    static let mediumDark = UIColor(hex: "37434E")!
    static let defaultWhite = UIColor(hex: "ecf3f0")!
    static let darkGreen = UIColor(hex: "3d5f5d")!
    static let lightGreen = UIColor(hex: "ADC4BD")!
    static let darkRed = UIColor(hex: "671d26")!
    static let black = UIColor(hex: "000000")!
    static let lightSandRose = UIColor(hex: "DCD8D9")!
    static let darkSandRose = UIColor(hex: "95888a")!
    
    static var navBarColor: UIColor { mediumDark }
    
    static let pcHarvestGold = UIColor(hex: "D8973C")!
    static let pcAlloyOrange = UIColor(hex: "BD632F")!
    static let pcFireOpal = UIColor(hex: "E3655B")!
    static let pcMiddleGreen = UIColor(hex: "5B8C5A")!
    static let pcParadisePink = UIColor(hex: "EA526F")!
    static let pcDodgerBlue = UIColor(hex: "279AF1")!
    static let pcLavenderFloral = UIColor(hex: "B191FF")!
    static let pcOrchid = UIColor(hex: "D664BE")!
    static let pcGlaucous = UIColor(hex: "657ED4")!
    static let pcBrightLilac = UIColor(hex: "C792DF")!
    static let pcEbony = UIColor(hex: "575A4B")!
    static let pcSteelTeal = UIColor(hex: "508991")!
    static let pcOrangeAerospace = UIColor(hex: "FF5714")!
    static let pcMauvelous = UIColor(hex: "FF9FB2")!
    static let pcOperaMauve = UIColor(hex: "B486AB")!
    
    static var pickerColors: [UIColor] {
        [
            Trip.defaultPinColor, pcHarvestGold, pcAlloyOrange, pcFireOpal,
            pcMiddleGreen, pcParadisePink, pcDodgerBlue, pcLavenderFloral,
            pcOrchid, pcGlaucous, pcBrightLilac, pcEbony,
            pcSteelTeal, pcOrangeAerospace, pcMauvelous, pcOperaMauve
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



