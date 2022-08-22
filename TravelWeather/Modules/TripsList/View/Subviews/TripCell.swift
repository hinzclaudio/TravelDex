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
        labelStack.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
    }
    
    
    func configure(for trip: Trip) {
        labelStack.removeAllArrangedSubviews()
        
        let titleLabel = UILabel()
        titleLabel.styleHeadline1()
        titleLabel.text = trip.title
        labelStack.addArrangedSubview(titleLabel)
        
        if let descr = trip.descr {
            let descrLabel = UILabel()
            descrLabel.styleText()
            descrLabel.text = descr
            labelStack.addArrangedSubview(descrLabel)
        }
        
        if let members = trip.members {
            let membersLabel = UILabel()
            membersLabel.styleSmall(lines: 0)
            membersLabel.text = members
            labelStack.addArrangedSubview(membersLabel)
        }
    }
    
}
