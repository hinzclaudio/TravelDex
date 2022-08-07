//
//  EditPlaceCell.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit



class EditPlaceCell: UIView {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let secLabel = UILabel()
    
    
    
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
        containerView.addSubview(secLabel)
    }
    
    private func configureViews() {
        titleLabel.styleHeadline2()
        secLabel.styleSmall()
        containerView.roundCorners()
        containerView.backgroundColor = Colors.darkSandRose
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: self, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -0.5 * Sizes.defaultMargin)
        
        titleLabel.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        titleLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        titleLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)

        secLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 0.5 * Sizes.defaultMargin)
        secLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        secLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        secLabel.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
    }
    
    func configure(for addedPlace: AddedPlaceItem) {
        titleLabel.text = addedPlace.location.name
        if let region = addedPlace.location.region {
            secLabel.text = "\(addedPlace.location.country), \(region)"
        } else {
            secLabel.text = addedPlace.location.country
        }
    }
    
}
