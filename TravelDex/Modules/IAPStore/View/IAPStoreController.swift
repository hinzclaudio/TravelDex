//
//  IAPStoreController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import UIKit
import RxSwift
import RxCocoa



class IAPStoreController: UIViewController {
    
    let viewModel: IAPStoreViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let tableView = UITableView()
    
    
    init(viewModel: IAPStoreViewModelType) {
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
        view.addSubview(tableView)
    }
    
    private func configureViews() {
        navigationItem.title = Localizable.iapStoreTitle
        view.backgroundColor = Colors.veryDark
        tableView.register(SKProductCell.self, forCellReuseIdentifier: SKProductCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setAutoLayout() {
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        viewModel.products
            .drive(
                tableView.rx.items(
                    cellIdentifier: SKProductCell.identifier,
                    cellType: SKProductCell.self
                )
            ) { i, product, cell in
                cell.configure(for: product)
            }
            .disposed(by: bag)
    }
    
}
