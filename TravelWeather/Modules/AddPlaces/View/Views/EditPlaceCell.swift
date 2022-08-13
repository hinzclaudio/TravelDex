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
    
    let cellTapRecognizer = UITapGestureRecognizer()
    let cellExpanded: PublishSubject<Bool> = .init()
    let bag = DisposeBag()
    
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
    let startPicker = UIDatePicker()
    private let endLabel = UILabel()
    let endPicker = UIDatePicker()
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
        datesPictureContainer.addSubview(startPicker)
        datesPictureContainer.addSubview(endLabel)
        datesPictureContainer.addSubview(endPicker)
        detailsStack.addArrangedSubview(customTextLabel)
    }
    
    private func configureViews() {
        containerView.addGestureRecognizer(cellTapRecognizer)
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
            
        titleLabel.styleHeadline2(colored: Colors.black)
        secLabel.styleSmall(colored: Colors.black)
        containerView.roundCorners()
        containerView.backgroundColor = Colors.lightSandRose
        
        optionsButton.tintColor = Colors.black
        optionsButton.setImage(SFSymbol.gear.image, for: .normal)
        optionsButton.showsMenuAsPrimaryAction = true
        
        startLabel.text = "Start"
        startLabel.styleSmall(colored: Colors.black)
        startPicker.styleDayMonthYear()
        
        endLabel.text = "End"
        endLabel.styleSmall(colored: Colors.black)
        endPicker.styleDayMonthYear()
        
        picturePreview.tintColor = Colors.black
        picturePreview.image = SFSymbol.camera.image
        picturePreview.contentMode = .scaleAspectFit
        
        customTextLabel.styleText(colored: Colors.black)
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
        picturePreview.autoMatch(.width, to: .width, of: datesPictureContainer, withMultiplier: 0.25)
        picturePreview.autoMatch(.height, to: .width, of: picturePreview)
        
        startLabel.autoPinEdge(.top, to: .top, of: datesPictureContainer)
        startLabel.autoPinEdge(.left, to: .right, of: picturePreview, withOffset: Sizes.defaultMargin)
        
        startPicker.autoPinEdge(.left, to: .right, of: startLabel, withOffset: Sizes.defaultMargin)
        startPicker.autoAlignAxis(.horizontal, toSameAxisOf: startLabel)
        
        endLabel.autoPinEdge(.top, to: .bottom, of: startLabel, withOffset: Sizes.defaultMargin)
        endLabel.autoPinEdge(.left, to: .right, of: picturePreview, withOffset: Sizes.defaultMargin)
        endLabel.autoPinEdge(.bottom, to: .bottom, of: datesPictureContainer)
        endLabel.autoMatch(.height, to: .height, of: startLabel)
        
        endPicker.autoPinEdge(.left, to: .right, of: endLabel, withOffset: Sizes.defaultMargin)
        endPicker.autoAlignAxis(.horizontal, toSameAxisOf: endLabel)
    }
    
    func configure(for addedPlace: AddedPlaceItem, menu: UIMenu) {
        titleLabel.text = addedPlace.location.name
        if let region = addedPlace.location.region {
            secLabel.text = "\(addedPlace.location.country), \(region)"
        } else {
            secLabel.text = addedPlace.location.country
        }
        
        customTextLabel.text = addedPlace.visitedPlace.text
        startPicker.date = addedPlace.visitedPlace.start
        endPicker.date = addedPlace.visitedPlace.end
        optionsButton.menu = menu
    }
    
}
