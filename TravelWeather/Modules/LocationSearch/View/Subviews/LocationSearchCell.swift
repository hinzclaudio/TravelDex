//
//  LocationSearchCell.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit



class LocationSearchCell: UITableViewCell {
    static let identifier = "LocationSearchTableViewCell"
    
    private let containerView = UIView()
    private let labelStack = UIStackView.defaultContentStack(withSpacing: 5)
    
    
    
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
        containerView.addSubview(labelStack)
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        containerView.roundCorners()
        containerView.backgroundColor = Colors.darkGreen
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: contentView, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: contentView, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -0.5 * Sizes.defaultMargin)
        
        labelStack.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        labelStack.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
    }
    
    func configure(for loc: Location) {
        labelStack.removeAllArrangedSubviews()
        
        let titleLabel = UILabel()
        titleLabel.styleText()
        titleLabel.text = loc.name
        labelStack.addArrangedSubview(titleLabel)
        
        let secLabel = UILabel()
        secLabel.styleSmall()
        labelStack.addArrangedSubview(secLabel)
        if let reg = loc.region {
            secLabel.text = "\(loc.country), \(reg)"
        } else {
            secLabel.text = loc.country
        }
    }
    
}
