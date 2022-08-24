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
    
    let searchLocationsTapped = PublishSubject<Void>()
    let addCustomLocationsTapped = PublishSubject<Void>()
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let mapButton = UIBarButtonItem()
    let addButton = UIBarButtonItem(systemItem: .add)
    
    let headerView = TripCell()
    let placesStack = UIStackView.defaultContentStack(withSpacing: 0)
    let saveButton = UIButton(type: .system)
    
    
    
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
        navigationItem.setRightBarButtonItems([addButton, mapButton], animated: false)
        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(placesStack)
    }
    
    private func configureViews() {
        navigationItem.title = "Add Places"
        view.backgroundColor = Colors.veryDark
        mapButton.image = SFSymbol.map.image
        
        let searchAction = UIAction(
            title: "Search Locations",
            image: SFSymbol.magnifyingglass.image,
            handler: { [weak self] _ in
                self?.searchLocationsTapped.onNext(())
            }
        )
        
        let addCustomAction = UIAction(
            title: "Add Custom Location",
            image: SFSymbol.map.image,
            handler: { [weak self] _ in
                self?.addCustomLocationsTapped.onNext(())
            }
        )
    
        addButton.menu = UIMenu(title: "Add Location", children: [searchAction, addCustomAction])
    }
    
    private func setAutoLayout() {
        headerView.autoMatch(.width, to: .width, of: view)
        placesStack.autoMatch(.width, to: .width, of: contentStack)
    }
    
    private func setupBinding() {
        
        
        viewModel.mapButton(mapButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        viewModel.trip
            .drive(onNext: { [weak self] trip in self?.headerView.configure(for: trip) })
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
        
        viewModel
            .searchLocation(searchLocationsTapped.asObservable())
            .disposed(by: bag)
        viewModel
            .addCustomLocation(addCustomLocationsTapped.asObservable())
            .disposed(by: bag)
    }
    
}
