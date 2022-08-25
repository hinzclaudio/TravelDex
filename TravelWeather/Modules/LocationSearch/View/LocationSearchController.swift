//
//  LocationSearchController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit



class LocationSearchController: UIViewController {
    
    let viewModel: LocationSearchViewModelType
    
    let selection = PublishSubject<Location>()
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let searchController = UISearchController()
    let mapView = MKMapView()
    let loadingView = UIActivityIndicatorView()
    
    
    
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
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        navigationItem.searchController = searchController
        view.addSubview(mapView)
    }
    
    private func configureViews() {
        navigationItem.title = "Search Locations"
        mapView.delegate = self
        searchController.searchBar.styleDefault()
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func setAutoLayout() {
        mapView.autoPinEdge(toSuperviewSafeArea: .top)
        mapView.autoPinEdge(.left, to: .left, of: view)
        mapView.autoPinEdge(.right, to: .right, of: view)
        mapView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        viewModel.errorController
            .drive(onNext: { [weak self] errorInfo in self?.present(errorInfo, animated: true) })
            .disposed(by: bag)
        
        viewModel.select(selection)
            .disposed(by: bag)
        
        let searchQuery = searchController.searchBar.rx
            .textDidEndEditing
            .map { [weak self] in self?.searchController.searchBar.text ?? "" }
        
        viewModel.annotations(for: searchQuery.startWith(""))
            .drive(mapView.rx.animatedAnnotations)
            .disposed(by: bag)
    }
    
}
