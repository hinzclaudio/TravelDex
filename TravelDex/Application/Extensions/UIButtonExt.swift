//
//  UIButtonExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



extension UIButton {
    
    func styleTextButton(colored c: UIColor = Colors.darkRed) {
        backgroundColor = .clear
        titleLabel?.font = Fonts.button
        setTitleColor(c, for: .normal)
        titleLabel?.autoSetDimension(.height, toSize: Sizes.defaultButtonHeight)
    }
    
    func styleBorderedButton() {
        backgroundColor = Colors.darkRed
        titleLabel?.font = Fonts.button
        setTitleColor(Colors.defaultWhite, for: .normal)
        titleLabel?.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        layer.borderColor = Colors.darkSandRose.cgColor
        layer.borderWidth = 1
        roundCorners()
    }
    
}
