//
//  AddPlacesController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift



class AddPlacesController: ScrollableVStackController {
    
    let viewModel: AddPlacesViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let mapButton = UIBarButtonItem()
    let headerView = TripCell()
    let placesStack = UIStackView.defaultContentStack(withSpacing: 0)
    let addButton = UIButton()
    
    
    init(viewModel: AddPlacesViewModelType) {
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
        navigationItem.setRightBarButton(mapButton, animated: false)
        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(placesStack)
        contentStack.addArrangedSubview(addButton)
    }
    
    private func configureViews() {
        navigationItem.title = "Add Places"
        view.backgroundColor = Colors.veryDark
        mapButton.image = SFSymbol.map.image
        addButton.styleBorderedButton()
        addButton.setTitle("Add Place", for: .normal)
    }
    
    private func setAutoLayout() {
        headerView.autoMatch(.width, to: .width, of: view)
        placesStack.autoMatch(.width, to: .width, of: contentStack)
        contentStack.setCustomSpacing(1.5 * Sizes.defaultMargin, after: placesStack)
        addButton.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        addButton.autoMatch(.width, to: .width, of: view, withOffset: -2 * Sizes.defaultMargin)
    }
    
    private func setupBinding() {
        viewModel.mapButton(mapButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        viewModel.trip
            .drive(onNext: { [weak self] trip in self?.headerView.configure(for: trip) })
            .disposed(by: bag)
        viewModel.trip
            .map { $0.visitedLocations.count == 0 }
            .distinctUntilChanged()
            .drive(placesStack.rx.isHidden)
            .disposed(by: bag)

        viewModel.addedPlaces
            .drive(onNext: { [weak self] places in
                self?.placesStack.removeAllArrangedSubviews()
                places.forEach { item in
                    let cell = EditPlaceCell()
                    cell.configure(for: item, menu: self?.viewModel.menu(for: item))

                    cell.startPicker.rx.date
                        .filter { $0 != item.visitedPlace.start }
                        .subscribe(onNext: { d in self?.viewModel.setStart(of: item, to: d) })
                        .disposed(by: cell.bag)
                    cell.endPicker.rx.date
                        .filter { $0 != item.visitedPlace.end }
                        .subscribe(onNext: { d in self?.viewModel.setEnd(of: item, to: d) })
                        .disposed(by: cell.bag)

                    self?.viewModel.expandedItems
                        .map { $0.contains(item.visitedPlace.id) }
                        .drive(cell.cellExpanded)
                        .disposed(by: cell.bag)
                    cell.cellTapRecognizer.rx.tap
                        .withLatestFrom(self?.viewModel.expandedItems ?? .just([]))
                        .map { $0.contains(item.visitedPlace.id) }
                        .subscribe(
                            onNext: { isExp in self?.viewModel.set(item, expanded: !isExp) }
                        )
                        .disposed(by: cell.bag)

                    self?.placesStack.addArrangedSubview(cell)
                    cell.autoMatch(.width, to: .width, of: self?.placesStack ?? UIView())
                }
            })
            .disposed(by: bag)
        
        let tappedAdd = addButton.rx.tap.asObservable()
        viewModel
            .addLocation(tappedAdd)
            .disposed(by: bag)
    }
    
}
