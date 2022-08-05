//
//  TitledTextView.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class TitledTextView: UIView {
    
    // MARK: - Views
    private let containerView = UIView()
    let titleLabel = UILabel()
    let descrLabel = UILabel()
    let textView = UITextView()
    
    
    
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
        containerView.addSubview(descrLabel)
        containerView.addSubview(textView)
    }
    
    private func configureViews() {
        titleLabel.stlyeHeadline2()
        descrLabel.styleSmall()
        textView.font = Fonts.text
        textView.backgroundColor = Colors.defaultWhite
        textView.textColor = Colors.defaultBackground
        textView.roundCorners()
        textView.delegate = self
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: self, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0.5 * Sizes.defaultMargin)
        
        titleLabel.autoPinEdge(.top, to: .top, of: containerView)
        titleLabel.autoPinEdge(.left, to: .left, of: containerView)
        titleLabel.autoPinEdge(.right, to: .right, of: containerView)
        
        descrLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 0.5 * Sizes.defaultMargin)
        descrLabel.autoPinEdge(.left, to: .left, of: containerView)
        descrLabel.autoPinEdge(.right, to: .right, of: containerView)
        
        textView.autoPinEdge(.top, to: .bottom, of: descrLabel, withOffset: 0.5 * Sizes.defaultMargin)
        textView.autoPinEdge(.left, to: .left, of: containerView)
        textView.autoPinEdge(.right, to: .right, of: containerView)
        textView.autoPinEdge(.bottom, to: .bottom, of: containerView)
        textView.autoSetDimension(.height, toSize: Sizes.defaultTextViewHeight)
    }
    
}



// MARK: - Delegate
extension TitledTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // TODO: Enforce a max character limit
        return true
    }
    
}
