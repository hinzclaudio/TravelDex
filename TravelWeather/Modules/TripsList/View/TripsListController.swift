//
//  TripsListController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import RxSwift



class TripsListController: UIViewController {
    
    let viewModel: TripsListViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let addButton = UIBarButtonItem(systemItem: .add)
    let editButton = UIBarButtonItem(systemItem: .edit)
    let searchController = UISearchController()
    
    
    init(viewModel: TripsListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        navigationItem.setLeftBarButton(editButton, animated: false)
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationItem.searchController = searchController
    }
    
    private func configureViews() {
        navigationItem.title = "Trips"
        view.backgroundColor = Colors.defaultBackground
    }
    
    private func setAutoLayout() {
        
    }
    
    private func setupBinding() {
        viewModel
            .addTapped(addButton.rx.tap.asObservable())
            .disposed(by: bag)
    }
    
}
