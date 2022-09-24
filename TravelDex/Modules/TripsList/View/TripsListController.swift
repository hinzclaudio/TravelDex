//
//  TripsListController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import RxSwift



class TripsListController: UIViewController {
    
    let viewModel: TripsListViewModelType
    
    let addTap = PublishSubject<Void>()
    let importTap = PublishSubject<Void>()
    let editingIP = PublishSubject<IndexPath>()
    let pickingColorIP = PublishSubject<IndexPath>()
    let deletionIP = PublishSubject<IndexPath>()
    let bag = DisposeBag()
    
    // MARK: - Views
    let storeButton = UIBarButtonItem()
    let mapButton = UIBarButtonItem()
    let addButton = UIBarButtonItem(systemItem: .add)
    let searchController = UISearchController()
    let tableView = UITableView()
    let addTripLabel = UILabel()
    
    
    init(viewModel: TripsListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        navigationItem.setLeftBarButton(storeButton, animated: false)
        navigationItem.setRightBarButtonItems([addButton, mapButton], animated: false)
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        view.addSubview(addTripLabel)
    }
    
    private func configureViews() {
        navigationItem.title = Localizable.tripsListTitle
        storeButton.image = SFSymbol.cart.image
        mapButton.image = SFSymbol.map.image
        searchController.searchBar.styleDefault()
        navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = Colors.veryDark
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TripsListTableCell.self, forCellReuseIdentifier: TripsListTableCell.identifier)
        
        addTripLabel.styleText()
        addTripLabel.textAlignment = .center
        addTripLabel.text = Localizable.missingTrips
        
        addButton.menu = UIMenu(
            title: Localizable.menuTitle,
            children: [
                UIAction(
                    title: Localizable.actionCreateTrip,
                    image: SFSymbol.plus.image,
                    handler: { [unowned self] _ in
                        self.addTap.onNext(())
                    }
                ),
                UIAction(
                    title: Localizable.actionImportTrip,
                    image: SFSymbol.download.image,
                    handler: { [unowned self] _ in
                        self.importTap.onNext(())
                    }
                )
            ]
        )
    }
    
    private func setAutoLayout() {
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 3 * Sizes.defaultMargin)
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 3 * Sizes.defaultMargin)
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 3 * Sizes.defaultMargin)
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 3 * Sizes.defaultMargin)
    }
    
    private func setupBinding() {
        viewModel
            .mapTapped(mapButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        viewModel
            .storeTapped(storeButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        viewModel.addTapped(addTap)
            .disposed(by: bag)
        
        viewModel.importTapped(importTap)
            .disposed(by: bag)
        
        viewModel.tripsIsEmpty
            .drive(tableView.rx.isHidden)
            .disposed(by: bag)
        viewModel.tripsIsEmpty
            .map { !$0 }
            .drive(addTripLabel.rx.isHidden)
            .disposed(by: bag)
        
        let searchQuery = searchController.searchBar.rx.text.orEmpty
            .asObservable()
        let trips = viewModel.trips(for: searchQuery)
        trips
            .drive(
                tableView.rx.items(
                    cellIdentifier: TripsListTableCell.identifier,
                    cellType: TripsListTableCell.self
                )
            ) { i, trip, cell in
                cell.configure(for: trip)
            }
            .disposed(by: bag)
    
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        let tripSelection = tableView.rx.modelSelected(Trip.self)
            .asObservable()
        viewModel
            .select(tripSelection)
            .disposed(by: bag)
        
        let tripDeletion = deletionIP
            .withLatestFrom(trips) { i, trips in trips[i.row] }
            .asObservable()
        viewModel.delete(tripDeletion)
            .disposed(by: bag)
        
        let tripEditing = editingIP
            .withLatestFrom(trips) { i, trips in trips[i.row] }
        viewModel.edit(tripEditing)
            .disposed(by: bag)
        
        let tripColorPicking = pickingColorIP
            .withLatestFrom(trips) { i, trips in trips[i.row] }
        viewModel.pickColor(for: tripColorPicking)
            .disposed(by: bag)
    }
    
}
