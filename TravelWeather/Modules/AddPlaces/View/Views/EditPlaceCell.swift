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
    
    private let mainView = UIView()
    private let labelsStack = UIStackView.defaultContentStack(withSpacing: 0)
    private let titleLabel = UILabel()
    private let secLabel = UILabel()
    private let optionsButton = UIButton()
    
    private let detailsStack = UIStackView.defaultContentStack()
    
    private let datesPictureContainer = UIView()
    private let picturePreview = UIImageView()
    private let startLabel = UILabel()
    private let endLabel = UILabel()
    private let customTextLabel = UILabel()
    
    
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
        
        cellStack.addArrangedSubview(mainView)
        mainView.addSubview(labelsStack)
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(secLabel)
        mainView.addSubview(optionsButton)
        
        cellStack.addArrangedSubview(detailsStack)
        detailsStack.addArrangedSubview(datesPictureContainer)
        datesPictureContainer.addSubview(picturePreview)
        datesPictureContainer.addSubview(startLabel)
        datesPictureContainer.addSubview(endLabel)
        detailsStack.addArrangedSubview(customTextLabel)
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
                            self?.detailsStack.isHidden = hidden
                        }
            })
            .disposed(by: bag)
            
        titleLabel.styleHeadline2()
        secLabel.styleSmall()
        containerView.roundCorners()
        containerView.backgroundColor = Colors.darkSandRose
        
        optionsButton.tintColor = Colors.defaultWhite
        optionsButton.setImage(SFSymbol.gear.image, for: .normal)
        optionsButton.showsMenuAsPrimaryAction = true
        
        startLabel.styleSmall()
        endLabel.styleSmall()
        startLabel.text = "Start: 01.01.2000"
        endLabel.text = "End: 02.02.2000"
        
        picturePreview.tintColor = Colors.defaultWhite
        picturePreview.image = SFSymbol.emptyImage.image
        picturePreview.contentMode = .scaleAspectFit
        
        customTextLabel.styleText()
        customTextLabel.text = "Das ist ein etwas längerer Text den ich über meine wunderbaren Reiseerlebnisse schreiben werde. Ach mein Gott was habe ich dort viel erlebt."
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
        
        mainView.autoMatch(.width, to: .width, of: cellStack)
        labelsStack.autoPinEdge(.top, to: .top, of: mainView)
        labelsStack.autoPinEdge(.left, to: .left, of: mainView)
        labelsStack.autoPinEdge(.right, to: .left, of: optionsButton, withOffset: -Sizes.defaultMargin)
        labelsStack.autoPinEdge(.bottom, to: .bottom, of: mainView)
        
        optionsButton.autoPinEdge(.right, to: .right, of: mainView)
        optionsButton.autoAlignAxis(.horizontal, toSameAxisOf: mainView)
        optionsButton.autoSetDimensions(to: Sizes.defaultIconButtonSIze)
        
        titleLabel.autoMatch(.width, to: .width, of: labelsStack)
        secLabel.autoMatch(.width, to: .width, of: labelsStack)
        
        detailsStack.autoMatch(.width, to: .width, of: cellStack)
        
        datesPictureContainer.autoMatch(.width, to: .width, of: detailsStack)
        picturePreview.autoPinEdge(.top, to: .top, of: datesPictureContainer)
        picturePreview.autoPinEdge(.left, to: .left, of: datesPictureContainer)
        picturePreview.autoPinEdge(.bottom, to: .bottom, of: datesPictureContainer)
        picturePreview.autoMatch(.width, to: .width, of: datesPictureContainer, withMultiplier: 0.2)
        picturePreview.autoMatch(.height, to: .width, of: picturePreview)
        
        startLabel.autoPinEdge(.top, to: .top, of: datesPictureContainer)
        startLabel.autoPinEdge(.left, to: .right, of: picturePreview, withOffset: Sizes.defaultMargin)
        startLabel.autoPinEdge(.right, to: .right, of: datesPictureContainer)
        
        endLabel.autoPinEdge(.top, to: .bottom, of: startLabel)
        endLabel.autoPinEdge(.left, to: .right, of: picturePreview, withOffset: Sizes.defaultMargin)
        endLabel.autoPinEdge(.right, to: .right, of: datesPictureContainer)
        endLabel.autoPinEdge(.bottom, to: .bottom, of: datesPictureContainer)
        endLabel.autoMatch(.height, to: .height, of: startLabel)
    }
    
    func configure(for addedPlace: AddedPlaceItem, menu: UIMenu) {
        optionsButton.menu = menu
        titleLabel.text = addedPlace.location.name
        if let region = addedPlace.location.region {
            secLabel.text = "\(addedPlace.location.country), \(region)"
        } else {
            secLabel.text = addedPlace.location.country
        }
    }
    
}
