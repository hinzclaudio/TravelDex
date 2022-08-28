//
//  ColorSelectionCell.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 28.08.22.
//

import UIKit



class ColorSelectionCell: UICollectionViewCell {
    static let identifier = "ColorSelectionCollectionViewCell"
    
    var color: UIColor? {
        didSet { containerView.backgroundColor = color ?? .clear }
    }
    
    
    // MARK: - Views
    private let containerView = UIView()
    
    
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
        contentView.addSubview(containerView)
    }
    
    private func configureViews() {
        backgroundColor = .clear
        containerView.roundCorners()
        containerView.backgroundColor = .clear
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: contentView, withOffset: Sizes.halfDefMargin)
        containerView.autoPinEdge(.left, to: .left, of: contentView, withOffset: Sizes.halfDefMargin)
        containerView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -Sizes.halfDefMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -Sizes.halfDefMargin)
    }
    
}
