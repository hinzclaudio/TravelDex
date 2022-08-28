//
//  Sizes.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import CoreGraphics
import UIKit



struct Sizes {
    
    static let defaultMargin: CGFloat = 15
    static var halfDefMargin: CGFloat { defaultMargin / 2 }
    
    static let colorPillSize: CGSize = .init(width: UIScreen.main.bounds.size.width / 6, height: 10)
    static let defaultCornerRadius: CGFloat = 10
    static let defaultTextViewHeight: CGFloat = 150
    static let defaultTextFieldHeight: CGFloat = 40
    static let defaultButtonHeight: CGFloat = 25
    static let defaultBorderButtonHeight: CGFloat = 50
    static let defaultIconButtonSIze = CGSize(width: 30, height: 30)
    static let defaultSnapshotHeight = CGFloat(150)
    
    static let smallImgPreview = CGSize(width: 50, height: 50)
}
