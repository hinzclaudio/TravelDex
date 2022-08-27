//
//  LocationEntryController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 27.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class LocationEntryController: ScrollableVStackController {
    
    let viewModel: LocationEntryViewModelType
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let titleField = TitledTextField()
    let regionField = TitledTextField()
    let countryField = TitledTextField()
    let snapshotView = UIImageView()
    let confirmButton = UIButton(type: .system)
    
    
    
    init(viewModel: LocationEntryViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        contentStack.addArrangedSubview(titleField)
        contentStack.addArrangedSubview(regionField)
        contentStack.addArrangedSubview(countryField)
        contentStack.addArrangedSubview(snapshotView)
        contentStack.addArrangedSubview(confirmButton)
    }
    
    private func configureViews() {
        navigationItem.title = "Add Location"
        view.backgroundColor = Colors.veryDark
        titleField.titleLabel.text = "Title"
        regionField.titleLabel.text = "Region"
        regionField.descrLabel.text = "(optional)"
        countryField.titleLabel.text = "Country"
        countryField.descrLabel.text = "(optional)"
        
        snapshotView.roundCorners()
        snapshotView.contentMode = .scaleAspectFill
        
        confirmButton.setTitle("Add Location", for: .normal)
        confirmButton.styleBorderedButton()
    }
    
    private func setAutoLayout() {
        titleField.autoMatch(.width, to: .width, of: contentStack)
        regionField.autoMatch(.width, to: .width, of: contentStack)
        countryField.autoMatch(.width, to: .width, of: contentStack)
        
        contentStack.setCustomSpacing(2 * Sizes.defaultMargin, after: countryField)
        snapshotView.autoSetDimension(.height, toSize: Sizes.defaultSnapshotHeight)
        snapshotView.autoMatch(.width, to: .width, of: contentStack, withOffset: -2 * Sizes.defaultMargin)
        
        contentStack.setCustomSpacing(1.5 * Sizes.defaultMargin, after: snapshotView)
        confirmButton.autoMatch(.width, to: .width, of: contentStack, withOffset: -2 * Sizes.defaultMargin)
        confirmButton.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        
        
    }
    
    private func setupBinding() {
        viewModel.title
            .bind(to: titleField.tf.rx.text)
            .disposed(by: bag)
        titleField.tf.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.title)
            .disposed(by: bag)
        
        viewModel.region
            .bind(to: regionField.tf.rx.text)
            .disposed(by: bag)
        regionField.tf.rx.text.asObservable().nilIfEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.region)
            .disposed(by: bag)
        
        viewModel.country
            .bind(to: countryField.tf.rx.text)
            .disposed(by: bag)
        countryField.tf.rx.text.asObservable().nilIfEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.country)
            .disposed(by: bag)
        
        viewModel.snapshot
            .drive(snapshotView.rx.image)
            .disposed(by: bag)
        
        viewModel.confirm(confirmButton.rx.tap.asObservable())
            .disposed(by: bag)
    }
    
}
