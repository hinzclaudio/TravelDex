//
//  ColoredPill.swift
//  TravelDex
//
//  Created by Claudio Hinz on 28.08.22.
//

import UIKit



class ColoredPill: UIView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
    }
    
    private func addViews() {
        
    }
    
    private func configureViews() {
        roundCorners(radius: Sizes.defaultCornerRadius / 2)
        layer.borderColor = Asset.TDColors.white.color.cgColor
        layer.borderWidth = 1.5
        backgroundColor = .red
    }
    
    private func setAutoLayout() {
        self.autoSetDimension(.width, toSize: Sizes.colorPillWidth)
    }
    
}
