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
    let titleLabel = UILabel()
    
    
    
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
        containerView.addSubview(titleLabel)
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        containerView.roundCorners()
        containerView.backgroundColor = Colors.darkGreen
        titleLabel.styleHeadline1()
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: contentView, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: contentView, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -0.5 * Sizes.defaultMargin)
        
        titleLabel.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        titleLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        titleLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        titleLabel.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
    }
    
}
