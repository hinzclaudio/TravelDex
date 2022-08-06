//
//  AddPlacesController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift



class AddPlacesController: ScrollableVStackController {
    
    let viewModel: AddPlacesViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let headerView = TripCell()
    let addButton = UIButton()
    
    
    init(viewModel: AddPlacesViewModelType) {
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
        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(addButton)
    }
    
    private func configureViews() {
        navigationItem.title = "Add Places"
        view.backgroundColor = Colors.veryDark
        addButton.styleBorderedButton()
        addButton.setTitle("Add Place", for: .normal)
    }
    
    private func setAutoLayout() {
        headerView.autoMatch(.width, to: .width, of: view)
        addButton.autoSetDimension(.height, toSize: Sizes.defaultBorderButtonHeight)
        addButton.autoMatch(.width, to: .width, of: view, withOffset: -2 * Sizes.defaultMargin)
    }
    
    private func setupBinding() {
        viewModel.trip
            .drive(onNext: { [weak self] trip in self?.headerView.configure(for: trip) })
            .disposed(by: bag)
    }
    
}
