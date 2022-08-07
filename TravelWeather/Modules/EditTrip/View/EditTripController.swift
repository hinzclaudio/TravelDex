//
//  EditTripController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class EditTripController: ScrollableVStackController {
    
    let viewModel: EditTripViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let vSpacer = UIView()
    let titleTf = TitledTextField()
    let descrTf = TitledTextView()
    let membersTf = TitledTextView()
    let confirmButton = UIButton(type: .system)
    
    
    
    init(viewModel: EditTripViewModelType) {
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
        setupRx()
    }
    
    private func addViews() {
        contentStack.addArrangedSubview(vSpacer)
        contentStack.addArrangedSubview(titleTf)
        contentStack.addArrangedSubview(descrTf)
        contentStack.addArrangedSubview(membersTf)
        contentStack.addArrangedSubview(confirmButton)
    }
    
    private func configureViews() {
        navigationItem.title = "Add Trip"
        view.backgroundColor = Colors.veryDark
        contentStack.spacing = 2 * Sizes.defaultMargin
        titleTf.titleLabel.text = "Title"
        descrTf.titleLabel.text = "Description"
        descrTf.descrLabel.text = "What was your trip about? (optional)"
        membersTf.titleLabel.text = "Fellow Travelers"
        membersTf.descrLabel.text = "Who was travelling with you? (optional)"
        confirmButton.setTitle("Add Trip", for: .normal)
        confirmButton.styleBorderedButton()
    }
    
    private func setAutoLayout() {
        contentStack.setCustomSpacing(0.5 * Sizes.defaultMargin, after: vSpacer)
        titleTf.autoMatch(.width, to: .width, of: view)
        descrTf.autoMatch(.width, to: .width, of: view)
        membersTf.autoMatch(.width, to: .width, of: view)
        contentStack.setCustomSpacing(2 * Sizes.defaultMargin, after: membersTf)
        confirmButton.autoMatch(.width, to: .width, of: view, withOffset: -2 * Sizes.defaultMargin)
    }
    
    private func setupRx() {
        let tripId = UUID()
        let title = titleTf.tf.rx.text
            .compactMap { $0 }
        let descr = descrTf.textView.rx.text.asObservable().nilIfEmpty
        let members = membersTf.textView.rx.text.asObservable().nilIfEmpty
        let currentTrip = Observable.combineLatest(title, descr, members)
            .map { t, d, m in Trip(id: tripId, title: t, descr: d, members: m, visitedLocations: []) }
        let confirmedTrip = confirmButton.rx.tap
            .withLatestFrom(currentTrip)
        viewModel
            .update(confirmedTrip)
            .disposed(by: bag)
    }
    
}
