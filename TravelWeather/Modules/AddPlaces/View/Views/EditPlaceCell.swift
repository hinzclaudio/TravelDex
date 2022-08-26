//
//  EditPlaceCell.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class EditPlaceCell: UITableViewCell {
    static let identifier = "EditPlaceTableViewCell"
    
    let cellTapRecognizer = UITapGestureRecognizer()
    let imageTapRecognizer = UITapGestureRecognizer()
    private let cellExpanded = BehaviorRelay(value: false)
    let isLoading = BehaviorRelay(value: false)
    
    private let persistentBag = DisposeBag()
    private(set) var bag = DisposeBag()
    
    
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
    let loadingView = UIActivityIndicatorView()
    let picturePreview = UIImageView()
    private let startLabel = UILabel()
    let startPicker = UIDatePicker()
    private let endLabel = UILabel()
    let endPicker = UIDatePicker()
    
    private let customTextLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
    }
    
    private func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(cellStack)
        
        cellStack.addArrangedSubview(mainView)
        mainView.addSubview(labelsStack)
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(secLabel)
        mainView.addSubview(optionsButton)
        
        cellStack.addArrangedSubview(detailsStack)
        detailsStack.addArrangedSubview(datesPictureContainer)
        datesPictureContainer.addSubview(picturePreview)
        datesPictureContainer.addSubview(loadingView)
        datesPictureContainer.addSubview(startLabel)
        datesPictureContainer.addSubview(startPicker)
        datesPictureContainer.addSubview(endLabel)
        datesPictureContainer.addSubview(endPicker)
        detailsStack.addArrangedSubview(customTextLabel)
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.addGestureRecognizer(cellTapRecognizer)
        cellExpanded
            .map { !$0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in self?.detailsStack.isHidden = $0 })
            .disposed(by: persistentBag)
        
        isLoading
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoading in
                self?.picturePreview.isHidden = isLoading
                self?.loadingView.isHidden = !isLoading
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            })
            .disposed(by: persistentBag)
            
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
        
        picturePreview.isUserInteractionEnabled = true
        picturePreview.clipsToBounds = true
        picturePreview.tintColor = Colors.black
        picturePreview.addGestureRecognizer(imageTapRecognizer)
        
        loadingView.isHidden = true
        
        customTextLabel.styleText(colored: Colors.black)
    }
    
    private func setAutoLayout() {
        containerView.autoPinEdge(.top, to: .top, of: contentView, withOffset: 0.5 * Sizes.defaultMargin)
        containerView.autoPinEdge(.left, to: .left, of: contentView, withOffset: Sizes.defaultMargin)
        containerView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -Sizes.defaultMargin)
        containerView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -0.5 * Sizes.defaultMargin)
        
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
        
        loadingView.autoPinEdge(.top, to: .top, of: datesPictureContainer)
        loadingView.autoPinEdge(.left, to: .left, of: datesPictureContainer)
        loadingView.autoPinEdge(.bottom, to: .bottom, of: datesPictureContainer)
        loadingView.autoMatch(.width, to: .width, of: datesPictureContainer, withMultiplier: 0.25)
        loadingView.autoMatch(.height, to: .width, of: picturePreview)
        
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
        
        customTextLabel.autoMatch(.width, to: .width, of: detailsStack)
    }
    
    func configure(for viewModel: EditPlaceViewModel, menu: UIMenu?) {
        titleLabel.text = viewModel.item.location.name
        secLabel.text = viewModel.item.location.supplementaryString
        
        if let imgData = viewModel.item.visitedPlace.picture,
           let img = UIImage(data: imgData) {
            picturePreview.image = img
            picturePreview.clipsToBounds = true
            picturePreview.contentMode = .scaleAspectFill
        } else {
            picturePreview.image = SFSymbol.camera.image
            picturePreview.clipsToBounds = false
            picturePreview.contentMode = .scaleAspectFit
        }
        
        customTextLabel.text = viewModel.item.visitedPlace.text
        startPicker.date = viewModel.item.visitedPlace.start
        endPicker.date = viewModel.item.visitedPlace.end
        optionsButton.menu = menu
        cellExpanded.accept(viewModel.expanded)
    }
    
}
