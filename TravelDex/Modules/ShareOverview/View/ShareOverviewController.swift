//
//  ShareOverviewController.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.03.23.
//

import UIKit
import RxSwift
import RxCocoa



class ShareOverviewController: UIViewController {
    
    let viewModel: ShareOverviewViewModelType
    let bag = DisposeBag()
    
    init(viewModel: ShareOverviewViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationItem.title = "This is a test!"
    }
    
}
