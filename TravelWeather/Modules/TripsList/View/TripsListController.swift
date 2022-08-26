//
//  TripsListController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import RxSwift



class TripsListController: UIViewController {
    
    let viewModel: TripsListViewModelType
    
    let editingIP = PublishSubject<IndexPath>()
    let deletionIP = PublishSubject<IndexPath>()
    let bag = DisposeBag()
    
    // MARK: - Views
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
        navigationItem.setRightBarButtonItems([addButton, mapButton], animated: false)
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        view.addSubview(addTripLabel)
    }
    
    private func configureViews() {
        navigationItem.title = "Trips"
        mapButton.image = SFSymbol.map.image
        searchController.searchBar.styleDefault()
        navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = Colors.veryDark
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TripsListTableCell.self, forCellReuseIdentifier: TripsListTableCell.identifier)
        
        addTripLabel.styleText()
        addTripLabel.textAlignment = .center
        addTripLabel.text = "You did not add any trips yet. Add a trip by tapping the plus icon!"
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
            .addTapped(addButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        let searchQuery = searchController.searchBar.rx.text.orEmpty.asObservable()
        let trips = viewModel.trips(for: searchQuery)
        
        let tripsAvailable = trips
            .map { !$0.isEmpty }
            .distinctUntilChanged()
        tripsAvailable
            .map { !$0 }
            .drive(tableView.rx.isHidden)
            .disposed(by: bag)
        tripsAvailable
            .drive(addTripLabel.rx.isHidden)
            .disposed(by: bag)
        
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
    }
    
}
