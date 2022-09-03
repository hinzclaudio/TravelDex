//
//  LocationDisplayController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.08.22.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa



class LocationDisplayController: UIViewController {
    
    let viewModel: LocationDisplayViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let mapView = MKMapView()
    
    
    init(viewModel: LocationDisplayViewModelType) {
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
        view.addSubview(mapView)
    }
    
    private func configureViews() {
        view.backgroundColor = Colors.veryDark
        
        mapView.delegate = self
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
    }
    
    private func setAutoLayout() {
        mapView.autoPinEdge(toSuperviewSafeArea: .top)
        mapView.autoPinEdge(.left, to: .left, of: view)
        mapView.autoPinEdge(.right, to: .right, of: view)
        mapView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        viewModel.controllerTitle
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        
        viewModel.annotations
            .drive(mapView.rx.animatedAnnotations)
            .disposed(by: bag)
    }
    
}
