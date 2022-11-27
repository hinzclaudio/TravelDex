//
//  LocationSearchController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit



class LocationSearchController: UIViewController {
    
    let viewModel: LocationSearchViewModelType
    
    let mapTapGesture = UILongPressGestureRecognizer()
    let selection = PublishSubject<Location>()
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let searchController = UISearchController()
    let mapView = MKMapView()
    let addButton = UIButton(type: .system)
    
    
    
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
        view.addSubview(addButton)
    }
    
    private func configureViews() {
        navigationItem.title = Localizable.searchLocationTitle
        view.backgroundColor = Asset.TDColors.background.color
        mapView.delegate = self
        mapView.addGestureRecognizer(mapTapGesture)
        
        searchController.searchBar.styleDefault()
        searchController.hidesNavigationBarDuringPresentation = false
        
        addButton.styleBorderedButton()
        addButton.setTitle(Localizable.actionAddLocation, for: .normal)
        addButton.isHidden = true
    }
    
    private func setAutoLayout() {
        mapView.autoPinEdge(toSuperviewSafeArea: .top)
        mapView.autoPinEdge(.left, to: .left, of: view)
        mapView.autoPinEdge(.right, to: .right, of: view)
        mapView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        addButton.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        addButton.autoPinEdge(.left, to: .left, of: view, withOffset: 2 * Sizes.defaultMargin)
        addButton.autoPinEdge(.right, to: .right, of: view, withOffset: -2 * Sizes.defaultMargin)
        addButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 3 * Sizes.defaultMargin)
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
            .startWith("")
        let annotations = viewModel
            .annotations(for: searchQuery)
        annotations
            .drive(mapView.rx.animatedAnnotations)
            .disposed(by: bag)
        
        let oneAndOnlyAnnotation = annotations
            .map { annotations -> MKAnnotation? in
                if annotations.count == 1 {
                    return annotations.first
                } else {
                    return nil
                }
            }
        oneAndOnlyAnnotation
            .map { $0 == nil }
            .distinctUntilChanged()
            .drive(addButton.rx.isHidden)
            .disposed(by: bag)
        addButton.rx.tap
            .withLatestFrom(oneAndOnlyAnnotation)
            .compactMap { a -> Location? in (a as? LocationSearchAnnotation)?.location }
            .bind(to: selection)
            .disposed(by: bag)
        
        let pressedCoordinate = mapTapGesture.rx.event
            .filter { $0.state == .began }
            .map { [unowned mapView] gesture -> Coordinate in
                let point = gesture.location(in: mapView)
                let coord = mapView.convert(point, toCoordinateFrom: mapView)
                return Coordinate(latitude: coord.latitude, longitude: coord.longitude)
            }
        viewModel
            .longPress(pressedCoordinate)
            .disposed(by: bag)
    }
    
}
