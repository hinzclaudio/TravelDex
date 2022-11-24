//
//  PremiumStoreController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import UIKit
import RxSwift
import RxCocoa



class PremiumStoreController: UIViewController {
    
    let viewModel: PremiumStoreViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let loadingOverlay = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    let infoButton = UIBarButtonItem()
    let optionsButton = UIBarButtonItem()
    let headerView = PremiumStoreHeader()
    let tableView = UITableView()
    
    
    
    init(viewModel: PremiumStoreViewModelType) {
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
        navigationItem.setLeftBarButton(infoButton, animated: false)
        navigationItem.setRightBarButton(optionsButton, animated: false)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
        
        loadingOverlay.addSubview(activityIndicator)
    }
    
    private func configureViews() {
        navigationItem.title = Localizable.iapStoreTitle
        view.backgroundColor = Colors.veryDark
        tableView.register(SKProductCell.self, forCellReuseIdentifier: SKProductCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        headerView.textLabel.text = Localizable.iapStoreDescription
        
        infoButton.image = SFSymbol.infoCircle.image
        
        let restoreAction = UIAction(
            title: Localizable.actionRestore,
            handler: { [weak self] _ in self?.viewModel.restorePurchases() }
        )
        optionsButton.menu = UIMenu(title: Localizable.menuTitle, children: [restoreAction])
        optionsButton.image = SFSymbol.gear.image
        
        loadingOverlay.backgroundColor = Colors.veryDark
        activityIndicator.transform = .init(scaleX: 1.5, y: 1.5)
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
        
        let tappedInfo = infoButton.rx.tap.asObservable()
        viewModel.info(tappedInfo)
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
        
        viewModel.isPurchasing
            .drive(onNext: { [unowned self] isPurchasing in
                if isPurchasing {
                    self.view.addSubview(loadingOverlay)
                    self.view.bringSubviewToFront(loadingOverlay)
                    self.loadingOverlay.frame = view.frame
                    self.loadingOverlay.alpha = 0
                    self.activityIndicator.center = self.loadingOverlay.center
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: AnimationConstants.defaultDuration) {
                        self.loadingOverlay.alpha = 1
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    if self.loadingOverlay.superview != nil{
                        UIView.animate(withDuration: AnimationConstants.defaultDuration) {
                            self.loadingOverlay.alpha = 0
                        } completion: { completed in
                            guard completed else { return }
                            self.loadingOverlay.removeFromSuperview()
                        }
                    }
                }
            })
            .disposed(by: bag)
    }
    
}
