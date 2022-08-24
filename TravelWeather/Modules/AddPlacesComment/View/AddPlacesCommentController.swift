//
//  AddPlacesCommentController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 24.08.22.
//

import UIKit



class AddPlacesCommentController: UIViewController {
    
    let viewModel: AddPlacesCommentViewModelType
    
    
    init(viewModel: AddPlacesCommentViewModelType) {
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
    
    
    
    // MARK: - Setup Funcs
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
