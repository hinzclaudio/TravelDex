//
//  TripCell.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit



class TripCell: UIView {
    
    // MARK: - Views
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
        self.addSubview(labelStack)
        self.addSubview(colorPill)
    }
    
    private func configureViews() {
        backgroundColor = .clear
    }
    
    private func setAutoLayout() {
        let vMargin = 1.5 * Sizes.defaultMargin
        
        colorPill.autoPinEdge(.top, to: .top, of: self, withOffset: vMargin)
        colorPill.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        colorPill.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -vMargin)
        
        labelStack.autoPinEdge(.top, to: .top, of: self, withOffset: vMargin)
        labelStack.autoPinEdge(.left, to: .right, of: colorPill, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        labelStack.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -vMargin)
    }
    
    
    func configure(for trip: Trip) {
        labelStack.removeAllArrangedSubviews()
        
        let titleLabel = UILabel()
        titleLabel.styleHeadline1()
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
            labelStack.addArrangedSubview(membersLabel)
            membersLabel.autoMatch(.width, to: .width, of: labelStack)
        }
        
        colorPill.backgroundColor = trip.pinColor
    }
    
}
