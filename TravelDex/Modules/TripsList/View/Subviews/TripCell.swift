//
//  TripCell.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class TripCell: UIView {
    
    // MARK: - Views
    let hStack = UIStackView.defaultContentStack(withSpacing: Sizes.defaultMargin)
    let labelStack = UIStackView.defaultContentStack(withSpacing: 0.5 * Sizes.defaultMargin)
    let titleLabel = UILabel()
    let descrLabel = UILabel()
    let membersLabel = UILabel()
    let colorPill = ColoredPill()
    let button = UIButton(type: .system)
    
    
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
        self.addSubview(hStack)
        hStack.addArrangedSubview(colorPill)
        hStack.addArrangedSubview(labelStack)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(descrLabel)
        labelStack.addArrangedSubview(membersLabel)
        hStack.addArrangedSubview(button)
    }
    
    private func configureViews() {
        hStack.axis = .horizontal
        backgroundColor = .clear
        titleLabel.styleHeadline1()
        descrLabel.styleText()
        membersLabel.styleSmall(lines: 0)
        button.tintColor = Asset.TDColors.button.color
        button.setImage(SFSymbol.multiplePersons.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
    }
    
    private func setAutoLayout() {
        let vMargin = 1.5 * Sizes.defaultMargin
        colorPill.autoPinEdge(.top, to: .top, of: self, withOffset: vMargin)
        colorPill.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        colorPill.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -vMargin)
        
        hStack.autoPinEdge(.top, to: .top, of: self, withOffset: vMargin)
        hStack.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        hStack.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        hStack.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -vMargin)
        
        titleLabel.autoMatch(.width, to: .width, of: labelStack)
        descrLabel.autoMatch(.width, to: .width, of: labelStack)
        membersLabel.autoMatch(.width, to: .width, of: labelStack)
        
        button.autoSetDimensions(to: Sizes.defaultIconButtonSize)
    }
    
    func configure(for trip: Trip) {
        titleLabel.text = trip.title
        descrLabel.text = trip.descr
        descrLabel.isHidden = (trip.descr == nil)
        membersLabel.text = trip.members
        membersLabel.isHidden = (trip.members == nil)
        colorPill.backgroundColor = trip.pinColor
    }
    
}
