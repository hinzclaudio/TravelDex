//
//  TripsListCell.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit



class TripsListCell: UITableViewCell {
    
    static let identifier = "TripsListTableViewCell"
    
    // MARK: - Views
    private let containerView = UIView()
    private let labelStack = UIStackView.defaultContentStack(withSpacing: 0.5 * Sizes.defaultMargin)
    
    override func prepareForReuse() {
        labelStack.removeAllArrangedSubviews()
    }
    
    
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
        backgroundColor = .clear
        selectionStyle = .none
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
    
    func configure(for trip: Trip) {
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
