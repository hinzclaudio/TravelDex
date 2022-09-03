//
//  ColorSelectionController.swift
//  TravelDex
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
    let tripCell = TripCell()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        view.addSubview(tripCell)
        view.addSubview(collectionView)
    }
    
    private func configureViews() {
        navigationItem.title = Localizable.colorSelectionTitle
        view.backgroundColor = Colors.veryDark
        
        collectionView.backgroundColor = .clear
        collectionView.register(ColorSelectionCell.self, forCellWithReuseIdentifier: ColorSelectionCell.identifier)
    }
    
    private func setAutoLayout() {
        tripCell.autoPinEdge(toSuperviewSafeArea: .top, withInset: Sizes.halfDefMargin)
        tripCell.autoPinEdge(.left, to: .left, of: view)
        tripCell.autoPinEdge(.right, to: .right, of: view)
        
        collectionView.autoPinEdge(.top, to: .bottom, of: tripCell, withOffset: Sizes.halfDefMargin)
        collectionView.autoPinEdge(.left, to: .left, of: view, withOffset: Sizes.halfDefMargin)
        collectionView.autoPinEdge(.right, to: .right , of: view, withOffset: -Sizes.halfDefMargin)
        collectionView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        viewModel.trip
            .drive(onNext: { [unowned self] in self.tripCell.configure(for: $0) })
            .disposed(by: bag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        viewModel.availableColors
            .drive(
                collectionView.rx
                    .items(
                        cellIdentifier: ColorSelectionCell.identifier,
                        cellType: ColorSelectionCell.self
                    )
            ) { i, color, cell in
                cell.color = color
            }
            .disposed(by: bag)
        
        let color = collectionView.rx.modelSelected(UIColor.self).asObservable()
        viewModel
            .select(color)
            .disposed(by: bag)
    }
    
}
