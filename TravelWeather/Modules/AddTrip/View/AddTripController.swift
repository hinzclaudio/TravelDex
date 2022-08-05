//
//  AddTripController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class AddTripController: UIViewController {
    
    let viewModel: AddTripViewModelType
    
    // MARK: - Views
    
    
    
    init(viewModel: AddTripViewModelType) {
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
        navigationItem.title = "Add Trip"
        view.backgroundColor = Colors.defaultBackground
    }
    
    private func setAutoLayout() {
        
    }
    
}
