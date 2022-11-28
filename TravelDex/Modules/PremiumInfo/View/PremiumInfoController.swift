//
//  PremiumInfoController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.09.22.
//

import UIKit
import RxSwift



class PremiumInfoController: UIViewController {
    
    let viewModel: PremiumInfoViewModelType
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let headerView = PremiumStoreHeader()
    let tableView = UITableView()
    
    
    init(viewModel: PremiumInfoViewModelType) {
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
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    private func configureViews() {
        navigationItem.title = Localizable.premiumInfoTitle
        view.backgroundColor = Asset.TDColors.background.color
        
        headerView.textLabel.text = Localizable.premiumInfoHeader
        
        tableView.register(PremiumInfoBulletPointCell.self, forCellReuseIdentifier: PremiumInfoBulletPointCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
    }
    
    private func setAutoLayout() {
        headerView.autoMatch(.width, to: .width, of: view)
        
        tableView.autoPinEdge(.top, to: .top, of: view)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        headerView.layoutIfNeeded()
    }
    
    private func setupBinding() {
        viewModel.premiumFeatureInfos
            .drive(
                tableView.rx.items(
                    cellIdentifier: PremiumInfoBulletPointCell.identifier,
                    cellType: PremiumInfoBulletPointCell.self
                )
            ) { i, info, cell in cell.text = info }
            .disposed(by: bag)
    }
    
}
