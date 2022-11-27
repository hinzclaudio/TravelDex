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
    
    var bag = DisposeBag()

    // MARK: - Views
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
    }
    
    private func addViews() {
        contentView.addSubview(labelStack)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(secLabel)
        contentView.addSubview(buyButton)
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = Asset.TDColors.background.color
        titleLabel.styleText()
        secLabel.styleSmall()
        buyButton.contentHorizontalAlignment = .right
    }
    
    private func setAutoLayout() {
        labelStack.autoPinEdge(.top, to: .top, of: contentView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.left, to: .left, of: contentView, withOffset: Sizes.defaultMargin)
        labelStack.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -Sizes.defaultMargin)
        
        titleLabel.autoMatch(.width, to: .width, of: labelStack)
        secLabel.autoMatch(.width, to: .width, of: labelStack)
        
        buyButton.autoPinEdge(.left, to: .right, of: labelStack, withOffset: Sizes.defaultMargin)
        buyButton.autoPinEdge(.right, to: .right, of: contentView, withOffset: -Sizes.defaultMargin)
        buyButton.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        buyButton.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
    }
    
    func configure(for iapProduct: PremiumProduct) {
        titleLabel.text = iapProduct.product.displayName
        secLabel.text = iapProduct.product.description
        
        buyButton.isEnabled = !iapProduct.isPurchased
        buyButton.setTitle(iapProduct.isPurchased ? Localizable.statusPurchased : iapProduct.product.displayPrice, for: .normal)
        buyButton.styleTextButton(colored: iapProduct.isPurchased ? Asset.TDColors.disabled.color : Asset.TDColors.button.color)
    }
    
}
