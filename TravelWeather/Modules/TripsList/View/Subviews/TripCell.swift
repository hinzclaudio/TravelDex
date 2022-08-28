//
//  TripCell.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit



class TripCell: UIView {
    
    // MARK: - Views
    let containerView = UIView()
    let labelStack = UIStackView.defaultContentStack(withSpacing: 0.5 * Sizes.defaultMargin)
    let colorPill = ColoredPill()
    
    
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
        containerView.addSubview(labelStack)
        containerView.addSubview(colorPill)
    }
    
    private func configureViews() {
        backgroundColor = .clear
        containerView.roundCorners()
        containerView.backgroundColor = Colors.darkGreen
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: self, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -0.5 * Sizes.defaultMargin)
        
        labelStack.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        
        colorPill.autoPinEdge(.top, to: .bottom, of: labelStack, withOffset: Sizes.defaultMargin)
        colorPill.autoAlignAxis(.vertical, toSameAxisOf: containerView)
        colorPill.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
    }
    
    
    func configure(for trip: Trip) {
        labelStack.removeAllArrangedSubviews()
        
        let titleLabel = UILabel()
        titleLabel.styleHeadline1()
        titleLabel.textAlignment = .center
        titleLabel.text = trip.title
        labelStack.addArrangedSubview(titleLabel)
        titleLabel.autoMatch(.width, to: .width, of: labelStack)
        
        if let descr = trip.descr {
            let descrLabel = UILabel()
            descrLabel.styleText()
            descrLabel.text = descr
            labelStack.addArrangedSubview(descrLabel)
            descrLabel.autoMatch(.width, to: .width, of: labelStack)
        }
        
        if let members = trip.members {
            let membersLabel = UILabel()
            membersLabel.styleSmall(lines: 0)
            membersLabel.text = members
            membersLabel.textAlignment = .center
            labelStack.addArrangedSubview(membersLabel)
            membersLabel.autoMatch(.width, to: .width, of: labelStack)
        }
        
        colorPill.backgroundColor = trip.pinColor
    }
    
}
