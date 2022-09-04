//
//  SKProductCell.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import UIKit
import StoreKit
import RxSwift



class SKProductCell: UITableViewCell {
    static let identifier = "SKProductTableViewCell"

    // MARK: - Views
    let containerView = UIView()
    let labelStack = UIStackView.defaultContentStack(withSpacing: Sizes.halfDefMargin)
    let titleLabel = UILabel()
    let secLabel = UILabel()
    let buyButton = UIButton(type: .system)
    
    
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
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(secLabel)
        containerView.addSubview(buyButton)
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.roundCorners()
        containerView.backgroundColor = Colors.lightSandRose
        titleLabel.styleHeadline3(colored: Colors.black)
        secLabel.styleSmall(colored: Colors.black)
        buyButton.contentHorizontalAlignment = .right
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: contentView, withOffset: Sizes.halfDefMargin)
        containerView.autoPinEdge(.left, to: .left, of: contentView, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -Sizes.halfDefMargin)
        
        labelStack.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
        
        titleLabel.autoMatch(.width, to: .width, of: labelStack)
        secLabel.autoMatch(.width, to: .width, of: labelStack)
        
        buyButton.autoPinEdge(.left, to: .right, of: labelStack, withOffset: Sizes.defaultMargin)
        buyButton.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        buyButton.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        buyButton.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
    }
    
    func configure(for iapProduct: IAPProduct) {
        titleLabel.text = iapProduct.product.displayName
        secLabel.text = iapProduct.product.displayPrice
        
        buyButton.isEnabled = !iapProduct.isPurchased
        buyButton.setTitle(iapProduct.isPurchased ? Localizable.statusPurchased : Localizable.actionPurchase, for: .normal)
        buyButton.styleTextButton(colored: iapProduct.isPurchased ? Colors.gray : Colors.darkRed)
    }
    
}
