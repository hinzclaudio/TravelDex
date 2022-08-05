//
//  TitledTextField.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class TitledTextField: UIView {
    
    // MARK: - Views
    private let containerView = UIView()
    private let hSpacer = UIView()
    let titleLabel = UILabel()
    let descrLabel = UILabel()
    let tf = PaddedTextField()
    
    
    
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
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descrLabel)
        containerView.addSubview(tf)
    }
    
    private func configureViews() {
        titleLabel.stlyeHeadline2()
        descrLabel.styleSmall()
        tf.roundCorners()
        tf.font = Fonts.text
        tf.backgroundColor = Colors.defaultWhite
        tf.textColor = Colors.defaultBackground
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: self, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0.5 * Sizes.defaultMargin)
        
        titleLabel.autoPinEdge(.top, to: .top, of: containerView)
        titleLabel.autoPinEdge(.left, to: .left, of: containerView)
        titleLabel.autoPinEdge(.right, to: .right, of: containerView)
        
        descrLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 0.5 * Sizes.defaultMargin)
        descrLabel.autoPinEdge(.left, to: .left, of: containerView)
        descrLabel.autoPinEdge(.right, to: .right, of: containerView)
        
        tf.autoPinEdge(.top, to: .bottom, of: descrLabel, withOffset: 0.5 * Sizes.defaultMargin)
        tf.autoPinEdge(.left, to: .left, of: containerView)
        tf.autoPinEdge(.right, to: .right, of: containerView)
        tf.autoPinEdge(.bottom, to: .bottom, of: containerView)
        tf.autoSetDimension(.height, toSize: Sizes.defaultTextFieldHeight)
    }
    
}
