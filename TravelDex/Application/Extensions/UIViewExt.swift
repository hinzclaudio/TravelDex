//
//  UIViewExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



extension UIView {
    
    func roundCorners(radius r: CGFloat = Sizes.defaultCornerRadius) {
        layer.masksToBounds = true
        layer.cornerRadius = r
    }
    
}
