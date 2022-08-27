//
//  LocationEntryController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 27.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class LocationEntryController: ScrollableVStackController {
    
    let viewModel: LocationEntryViewModelType
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let titleField = TitledTextField()
    let regionField = TitledTextField()
    let coiuntryField = TitledTextField()
    
    
    
    init(viewModel: LocationEntryViewModelType) {
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
        view.backgroundColor = Colors.darkRed
    }
    
    private func configureViews() {
        
    }
    
    private func setAutoLayout() {
        
    }
    
    private func setupBinding() {
        
    }
    
}
