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
    let bag = DisposeBag()
    
    // MARK: - Views
    let addButton = UIBarButtonItem(systemItem: .add)
    let searchController = UISearchController()
    let tableView = UITableView()
    
    
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
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationItem.searchController = searchController
        view.addSubview(tableView)
    }
    
    private func configureViews() {
        navigationItem.title = "Trips"
        view.backgroundColor = Colors.veryDark
        tableView.backgroundColor = .clear
        tableView.register(TripsListCell.self, forCellReuseIdentifier: TripsListCell.identifier)
    }
    
    private func setAutoLayout() {
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        viewModel
            .addTapped(addButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        let searchQuery = searchController.searchBar.rx.text.orEmpty.asObservable()
        let trips = viewModel.trips(for: searchQuery)
        trips
            .drive(
                tableView.rx.items(
                    cellIdentifier: TripsListCell.identifier,
                    cellType: TripsListCell.self
                )
            ) { i, trip, cell in cell.configure(for: trip) }
            .disposed(by: bag)
    }
    
}
