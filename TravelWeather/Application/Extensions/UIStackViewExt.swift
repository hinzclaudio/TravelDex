//
//  UIStackViewExt.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



extension UIStackView {
    
    static func defaultContentStack(withSpacing s: CGFloat = Sizes.defaultMargin) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = s
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
}
