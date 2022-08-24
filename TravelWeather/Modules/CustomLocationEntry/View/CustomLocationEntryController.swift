//
//  CustomLocationEntryController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 22.08.22.
//

import UIKit



class CustomLocationEntryController: UIViewController {
    
    let viewModel: CustomLocationEntryViewModelType
    
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
        
    }
    
    private func configureViews() {
        
    }
    
    private func setAutoLayout() {
    
    }
    
    private func setupBinding() {
        
    }
    
}
