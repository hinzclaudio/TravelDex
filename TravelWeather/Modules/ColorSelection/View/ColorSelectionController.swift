//
//  ColorSelectionController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 28.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class ColorSelectionController: UIViewController {
    
    let viewModel: ColorSelectionViewModelType
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    
    init(viewModel: ColorSelectionViewModelType) {
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
        view.addSubview(collectionView)
    }
    
    private func configureViews() {
        navigationItem.title = "Color Selection"
        view.backgroundColor = Colors.veryDark
        collectionView.backgroundColor = .clear
    }
    
    private func setAutoLayout() {
        collectionView.autoPinEdge(toSuperviewSafeArea: .top)
        collectionView.autoPinEdge(.right, to: .right , of: view)
        collectionView.autoPinEdge(.left, to: .left, of: view)
        collectionView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        
    }
    
}
