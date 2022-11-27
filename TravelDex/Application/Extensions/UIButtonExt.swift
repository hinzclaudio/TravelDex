//
//  UIButtonExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



extension UIButton {
    
    func styleTextButton(colored c: UIColor = Asset.TDColors.buttonText.color) {
        backgroundColor = .clear
        titleLabel?.font = Fonts.button
        setTitleColor(c, for: .normal)
        titleLabel?.autoSetDimension(.height, toSize: Sizes.defaultButtonHeight)
    }
    
    func styleBorderedButton() {
        backgroundColor = Asset.TDColors.buttonBackground.color
        titleLabel?.font = Fonts.button
        setTitleColor(Asset.TDColors.white.color, for: .normal)
        titleLabel?.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        layer.borderColor = Asset.TDColors.text.color.cgColor
        layer.borderWidth = 1
        roundCorners()
    }
    
}
