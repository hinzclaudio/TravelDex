//
//  LocationDisplayController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 11.08.22.
//

import UIKit
import MapKit



class LocationDisplayController: UIViewController {
    
    let viewModel: LocationDisplayViewModelType
    
    // MARK: - Views
    let mapView = MKMapView()
    
    
    init(viewModel: LocationDisplayViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        
    }
    
    private func configureViews() {
        
    }
    
    private func setAutoLayout() {
        
    }
    
    private func setupBinding() {
        
    }
    
}
