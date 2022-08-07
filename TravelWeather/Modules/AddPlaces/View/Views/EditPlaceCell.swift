//
//  EditPlaceCell.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class EditPlaceCell: UIView {
    
    private let cellExpanded = BehaviorSubject(value: false)
    private let cellTapRecognizer = UITapGestureRecognizer()
    private let bag = DisposeBag()
    
    // MARK: - Views
    private let containerView = UIView()
    private let cellStack = UIStackView.defaultContentStack()
    private let titleLabel = UILabel()
    private let secLabel = UILabel()
    private let controlStack = UIStackView.defaultContentStack()
    
    
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
        containerView.addSubview(cellStack)
        cellStack.addArrangedSubview(titleLabel)
        cellStack.addArrangedSubview(secLabel)
        cellStack.addArrangedSubview(controlStack)
    }
    
    private func configureViews() {
        containerView.addGestureRecognizer(cellTapRecognizer)
        cellTapRecognizer.rx.tap
            .withLatestFrom(cellExpanded)
            .map { !$0 }
            .bind(to: cellExpanded)
            .disposed(by: bag)
        
        cellExpanded
            .map { !$0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] hidden in
                UIView
                    .animate(
                        withDuration: AnimationConstants.defaultDuration,
                        delay: 0,
                        options: AnimationConstants.defaultOption) {
                            self?.controlStack.isHidden = hidden
                        }
            })
            .disposed(by: bag)
            
        titleLabel.styleHeadline2()
        secLabel.styleSmall()
        containerView.roundCorners()
        containerView.backgroundColor = Colors.darkSandRose
        
        let label = UILabel()
        label.styleHeadline1(colored: .red)
        controlStack.removeAllArrangedSubviews()
        controlStack.addArrangedSubview(label)
        label.text = "TESTLABEL"
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: self, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: self, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: self, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -0.5 * Sizes.defaultMargin)
        
        cellStack.autoPinEdge(.top, to: .top, of: containerView, withOffset: Sizes.defaultMargin)
        cellStack.autoPinEdge(.left, to: .left, of: containerView, withOffset: Sizes.defaultMargin)
        cellStack.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Sizes.defaultMargin)
        cellStack.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -Sizes.defaultMargin)
        
        titleLabel.autoMatch(.width, to: .width, of: cellStack)
        secLabel.autoMatch(.width, to: .width, of: cellStack)
        controlStack.autoMatch(.width, to: .width, of: cellStack)
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
