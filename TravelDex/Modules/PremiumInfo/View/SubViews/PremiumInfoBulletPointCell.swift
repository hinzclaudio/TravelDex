//
//  PremiumInfoBulletPoint.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.09.22.
//

import UIKit



class PremiumInfoBulletPointCell: UITableViewCell {
    static let identifier = "PremiumInfoBulletPointTableCell"
    
    var text: String? {
        didSet { infoLabel.text = text }
    }
    
    // MARK: - Views
    private let containerView = UIView()
    private let infoIcon = UIImageView()
    private let infoLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        containerView.addSubview(infoIcon)
        containerView.addSubview(infoLabel)
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView.roundCorners()
        containerView.backgroundColor = Colors.lightSandRose
        
        infoIcon.image = SFSymbol.infoCircle.image
        infoIcon.contentMode = .scaleAspectFit
        infoIcon.tintColor = Colors.black
        
        infoLabel.styleText(colored: Colors.black)
        infoLabel.text = text
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: contentView, withOffset: Sizes.halfDefMargin)
        containerView.autoPinEdge(.left, to: .left, of: contentView, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -Sizes.halfDefMargin)
        
        infoIcon.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        infoIcon.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
        infoIcon.autoSetDimensions(to: Sizes.defaultIconButtonSIze)
        
        infoLabel.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        infoLabel.autoPinEdge(.left, to: .right, of: infoIcon, withOffset: Sizes.defaultMargin)
        infoLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        infoLabel.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
    }
    
}

