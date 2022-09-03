//
//  PaddedTextField.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class PaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            x: bounds.origin.x + 0.5 * Sizes.defaultMargin,
            y: bounds.origin.y,
            width: bounds.width,
            height: bounds.height
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            x: bounds.origin.x + 0.5 * Sizes.defaultMargin,
            y: bounds.origin.y,
            width: bounds.width,
            height: bounds.height
        )
    }
    
}
