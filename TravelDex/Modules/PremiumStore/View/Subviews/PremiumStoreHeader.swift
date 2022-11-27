//
//  PremiumStoreHeader.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import UIKit



class PremiumStoreHeader: UIView {
    
    // MARK: - Views
    let containerView = UIView()
    let textLabel = UILabel()
    
    
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
        self.addSubview(containerView)
        containerView.addSubview(textLabel)
    }
    
    private func configureViews() {
        backgroundColor = .clear
        containerView.roundCorners()
        containerView.backgroundColor = Asset.TDColors.headerBackground.color
        
        textLabel.styleText()
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: self, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -Sizes.halfDefMargin)
        
        textLabel.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        textLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        textLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        textLabel.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
    }
    
}
