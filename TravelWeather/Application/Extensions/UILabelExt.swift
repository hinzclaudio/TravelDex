//
//  UILabel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



extension UILabel {
    
    func styleHeadline1(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.headline2
        sizeToFit()
    }
    
    
    func styleHeadline2(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
        numberOfLines = lines
        textColor = c
        font = Fonts.headline2
        sizeToFit()
    }
    
    
    func styleHeadline3(colored c: UIColor = Colors.defaultWhite, lines: Int = 0) {
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


