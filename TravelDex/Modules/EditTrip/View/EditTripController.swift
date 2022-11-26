//
//  EditTripController.swift
//  TravelDex
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
        navigationItem.title = Localizable.addTripTitle
        view.backgroundColor = Asset.TDColors.background.color
        contentStack.spacing = 2 * Sizes.defaultMargin
        titleTf.titleLabel.text = Localizable.tripNameTfTitle
        descrTf.titleLabel.text = Localizable.tripDescrTfTitle
        descrTf.descrLabel.text = Localizable.tripDescrTfSubtitle
        membersTf.titleLabel.text = Localizable.tripMembersTfTitle
        membersTf.descrLabel.text = Localizable.tripMembersTfSubtitle
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
        // Here, a simple binding by using .rx.text is not possible as the control
        // state is always reset when setting a new value. We can prevent this by also binding
        // to our own relay.
        let titleTextRelay = BehaviorRelay(value: "")
        viewModel.trip
            .map { $0?.title }
            .drive(titleTf.tf.rx.text)
            .disposed(by: bag)
        viewModel.trip
            .compactMap { $0?.title }
            .drive(titleTextRelay)
            .disposed(by: bag)
        titleTf.tf.rx.text.orEmpty
            .bind(to: titleTextRelay)
            .disposed(by: bag)
        
        viewModel.trip
            .map { $0?.descr }
            .drive(descrTf.textView.rx.text)
            .disposed(by: bag)
        viewModel.trip
            .map { $0?.members }
            .drive(membersTf.textView.rx.text)
            .disposed(by: bag)
        viewModel.confirmButtonTitle
            .drive(confirmButton.rx.title(for: .normal))
            .disposed(by: bag)
        
        let tripId = TripID()
        let descr = descrTf.textView.rx.text.asObservable().nilIfEmpty
        let members = membersTf.textView.rx.text.asObservable().nilIfEmpty
        
        let editedTrip = Observable.combineLatest(
            viewModel.trip.asObservable(),
            titleTextRelay,
            descr,
            members
        )
            .map { trip, t, d, m in
                Trip(
                    id: trip?.id ?? tripId,
                    title: t,
                    descr: d,
                    members: m,
                    visitedLocations: trip?.visitedLocations ?? [],
                    pinColorRed: trip?.pinColorRed ?? Trip.defaultPinColorRed,
                    pinColorGreen: trip?.pinColorGreen ?? Trip.defaultPinColorGreen,
                    pinColorBlue: trip?.pinColorBlue ?? Trip.defaultPinColorBlue
                )
            }
        
        let confirmedTrip = confirmButton.rx.tap
            .withLatestFrom(editedTrip)
        viewModel
            .update(confirmedTrip)
            .disposed(by: bag)
    }
    
}
