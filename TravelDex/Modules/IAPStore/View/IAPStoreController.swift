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
    let optionsButton = UIBarButtonItem()
    let headerView = IAPHeader()
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
        navigationItem.setRightBarButton(optionsButton, animated: false)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    private func configureViews() {
        navigationItem.title = Localizable.iapStoreTitle
        view.backgroundColor = Colors.veryDark
        tableView.register(SKProductCell.self, forCellReuseIdentifier: SKProductCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        let restoreAction = UIAction(
            title: Localizable.actionRestore,
            handler: { [weak self] _ in self?.viewModel.restorePurchases() }
        )
        optionsButton.menu = UIMenu(title: Localizable.menuTitle, children: [restoreAction])
        optionsButton.image = SFSymbol.gear.image
    }
    
    private func setAutoLayout() {
        headerView.autoMatch(.width, to: .width, of: view)
        
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        headerView.layoutIfNeeded()
    }
    
    private func setupBinding() {
        viewModel.errorAlert.asObservable()
            .subscribe(onNext: { [weak self] in self?.present($0, animated: true) })
            .disposed(by: bag)
        
        viewModel.products
            .drive(
                tableView.rx.items(
                    cellIdentifier: SKProductCell.identifier,
                    cellType: SKProductCell.self
                )
            ) { [unowned self] i, product, cell in
                cell.configure(for: product)
                let purchase = cell.buyButton.rx.tap
                    .withLatestFrom(self.viewModel.products) { _, prods in prods[i].product }
                    .asObservable()
                self.viewModel
                    .purchase(product: purchase)
                    .disposed(by: cell.bag)
            }
            .disposed(by: bag)
    }
    
}
