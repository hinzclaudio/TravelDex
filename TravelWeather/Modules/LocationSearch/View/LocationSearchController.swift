//
//  LocationSearchController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class LocationSearchController: UIViewController {
    
    let viewModel: LocationSearchViewModelType
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let searchController = UISearchController()
    
    let contentStack = UIStackView.defaultContentStack(withSpacing: Sizes.defaultMargin)
    let loadingView = UIActivityIndicatorView()
    let tableView = UITableView()
    
    
    
    init(viewModel: LocationSearchViewModelType) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        view.addSubview(loadingView)
    }
    
    private func configureViews() {
        navigationItem.title = "Search Locations"
        searchController.searchBar.styleDefault()
        view.backgroundColor = Colors.veryDark
        
        tableView.backgroundColor = .clear
        tableView.register(LocationSearchCell.self, forCellReuseIdentifier: LocationSearchCell.identifier)
    }
    
    private func setAutoLayout() {
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        loadingView.autoCenterInSuperview()
        loadingView.transform = .init(scaleX: 1.5, y: 1.5)
        loadingView.tintColor = Colors.defaultWhite
    }
    
    private func setupBinding() {
        viewModel.isLoading
            .drive(onNext: { [weak self] isLoading in
                UIView
                    .animate(
                        withDuration: AnimationConstants.defaultDuration,
                        delay: 0,
                        options: AnimationConstants.defaultOption) {
                            self?.loadingView.isHidden = !isLoading
                            self?.tableView.isHidden = isLoading
                        } completion: { [weak self] _ in
                            if isLoading{
                                self?.loadingView.startAnimating()
                            } else {
                                self?.loadingView.stopAnimating()
                            }
                        }
            })
            .disposed(by: bag)
        
        viewModel.errorController
            .drive(onNext: { [weak self] errorInfo in self?.present(errorInfo, animated: true) })
            .disposed(by: bag)
        
        let searchQuery = searchController.searchBar.rx.text.orEmpty
            .asObservable()
        let results = viewModel.searchResults(for: searchQuery)
        results
            .drive(
                tableView.rx.items(
                    cellIdentifier: LocationSearchCell.identifier,
                    cellType: LocationSearchCell.self
                )
            ) { i, location, cell in
                cell.configure(for: location)
            }
            .disposed(by: bag)
        
        let locationSelection = tableView.rx
            .modelSelected(Location.self)
            .asObservable()
        viewModel
            .select(locationSelection)
            .disposed(by: bag)
    }
    
}
