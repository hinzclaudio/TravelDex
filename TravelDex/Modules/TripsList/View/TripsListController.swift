//
//  TripsListController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class TripsListController: UIViewController {
    
    let viewModel: TripsListViewModelType
    let addTap = PublishRelay<Void>()
    let importTap = PublishRelay<Void>()
    let exportIP = PublishRelay<IndexPath>()
    let editingIP = PublishRelay<IndexPath>()
    let pickingColorIP = PublishRelay<IndexPath>()
    let deletionIP = PublishRelay<IndexPath>()
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
        viewModel.onDidLoad()
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
        view.backgroundColor = Asset.TDColors.background.color
        
        storeButton.image = SFSymbol.cart.image
        mapButton.image = SFSymbol.map.image
        
        searchController.searchBar.styleDefault()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
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
                        self.addTap.accept(())
                    }
                ),
                UIAction(
                    title: Localizable.actionImportTrip,
                    image: SFSymbol.download.image,
                    handler: { [unowned self] _ in
                        self.importTap.accept(())
                    }
                )
            ]
        )
    }
    
    private func setAutoLayout() {
        tableView.autoPinEdge(.top, to: .top, of: view)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 3 * Sizes.defaultMargin)
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 3 * Sizes.defaultMargin)
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 3 * Sizes.defaultMargin)
        addTripLabel.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 3 * Sizes.defaultMargin)
    }
    
    private func setupBinding() {
        mapButton.rx.tap
            .bind(to: viewModel.mapTapped)
            .disposed(by: bag)
        
        storeButton.rx.tap
            .bind(to: viewModel.storeTapped)
            .disposed(by: bag)

        addTap.bind(to: viewModel.addTapped)
            .disposed(by: bag)
        
        importTap.bind(to: viewModel.importTapped)
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
            ) { [weak self] i, trip, cell in
                cell.configure(for: trip)
                cell.view.button.rx.tap
                    .subscribe(onNext: { self?.viewModel.shareTrip.accept(trip) })
                    .disposed(by: cell.bag)
            }
            .disposed(by: bag)
    
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .withLatestFrom(trips) { $1[$0.row] }
            .bind(to: viewModel.selectTrip)
            .disposed(by: bag)
        tableView.rx.itemDeleted
            .bind(to: deletionIP)
            .disposed(by: bag)
        
        deletionIP
            .withLatestFrom(trips) { i, trips in trips[i.row] }
            .bind(to: viewModel.deleteTrip)
            .disposed(by: bag)
        
        editingIP
            .withLatestFrom(trips) { i, trips in trips[i.row] }
            .bind(to: viewModel.editTrip)
            .disposed(by: bag)
        
        pickingColorIP
            .withLatestFrom(trips) { i, trips in trips[i.row] }
            .bind(to: viewModel.pickColorForTrip)
            .disposed(by: bag)
        
        exportIP
            .withLatestFrom(trips) { i, trips in trips[i.row] }
            .bind(to: viewModel.exportTrip)
            .disposed(by: bag)
        
        viewModel.errorController.asObservable()
            .subscribe(onNext: { [weak self] alert in self?.present(alert, animated: true) })
            .disposed(by: bag)
    }
    
}
