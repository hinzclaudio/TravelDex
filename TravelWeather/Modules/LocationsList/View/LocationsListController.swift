//
//  LocationsListController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class LocationsListController: UIViewController {
    
    let viewModel: LocationsListViewModelType
    
    // MARK: - Views
    // TODO...
    
    
    init(viewModel: LocationsListViewModelType) {
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
    }
    
    private func addViews() {
        
    }
    
    private func configureViews() {
        navigationItem.title = "Locations"
        view.backgroundColor = .lightGray
    }
    
    private func setAutoLayout() {
        
    }
    
}
