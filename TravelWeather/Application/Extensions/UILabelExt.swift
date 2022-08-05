//
//  UILabel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



extension UILabel {
    
    func stlyeHeadline1(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.headline2
        sizeToFit()
    }
    
    
    func stlyeHeadline2(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.headline2
        sizeToFit()
    }
    
    
    func stlyeHeadline3(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.headline3
        sizeToFit()
    }
    
    
    func styleButtonText(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.button
        sizeToFit()
    }
    
    
    func styleText(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.text
        sizeToFit()
    }
    
    
    func styleSmall(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.small
        sizeToFit()
    }
    
}


