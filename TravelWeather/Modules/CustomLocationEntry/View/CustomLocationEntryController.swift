//
//  CustomLocationEntryController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 22.08.22.
//

import UIKit
import MapKit
import RxSwift



class CustomLocationEntryController: UIViewController {
    
    let viewModel: CustomLocationEntryViewModelType
    
    let displayedRegion = PublishSubject<MKCoordinateRegion>()
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let mapView = MKMapView()
    
    
    init(viewModel: CustomLocationEntryViewModelType) {
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
        navigationItem.title = "Add Custom Location"
        view.backgroundColor = Colors.veryDark
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func setAutoLayout() {
        mapView.autoPinEdge(toSuperviewSafeArea: .top)
        mapView.autoPinEdge(.left, to: .left, of: view)
        mapView.autoPinEdge(.right, to: .right, of: view)
        mapView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        let loc = Location(id: LocationID(), name: "Hamburg", coordinate: .init(latitude: 53.548, longitude: 9.991))
        Observable.just(loc.coordinate)
            .map { [DragAnnotation(coordinate: $0)] }
            .bind(to: mapView.rx.animatedAnnotations)
            .disposed(by: bag)
        
        displayedRegion
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .debug("REGION")
            .do(onNext: { [weak self] _ in
                guard let annotations = self?.mapView.annotations else { return }
                self?.mapView.removeAnnotations(annotations)
            })
            .map { region in
                let coordinate = Coordinate(latitude: region.center.latitude, longitude: region.center.longitude)
                return [DragAnnotation(coordinate: coordinate)]
            }
            .bind(to: mapView.rx.nonAnimatedAnnotations)
            .disposed(by: bag)
    }
    
}
