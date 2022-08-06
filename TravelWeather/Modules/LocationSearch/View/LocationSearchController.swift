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
    }
    
    private func addViews() {
        
    }
    
    private func configureViews() {
        navigationItem.title = "Search Locations"
        navigationItem.searchController = searchController
        view.backgroundColor = Colors.veryDark
    }
    
    private func setAutoLayout() {
        
    }
    
}
