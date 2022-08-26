//
//  AddPlacesController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class AddPlacesController: UIViewController {
    
    let viewModel: AddPlacesViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let mapButton = UIBarButtonItem()
    let addButton = UIBarButtonItem(systemItem: .add)
    
    let headerView = TripCell()
    let tableView = UITableView()
    
    let headerTapRecognizer = UITapGestureRecognizer()
    
    
    
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
        navigationItem.setRightBarButtonItems([addButton, mapButton], animated: false)
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }
    
    private func configureViews() {
        navigationItem.title = "Add Places"
        view.backgroundColor = Colors.veryDark
        headerView.addGestureRecognizer(headerTapRecognizer)
        mapButton.image = SFSymbol.map.image
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(EditPlaceCell.self, forCellReuseIdentifier: EditPlaceCell.identifier)
    }
    
    private func setAutoLayout() {
        headerView.autoMatch(.width, to: .width, of: view)
        
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
    }
    
    private func setupBinding() {
        viewModel.mapButton(mapButton.rx.tap.asObservable())
            .disposed(by: bag)
        viewModel
            .addLocation(addButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        viewModel.trip
            .drive(onNext: { [weak self] trip in
                self?.headerView.configure(for: trip)
                self?.headerView.layoutIfNeeded()
            })
            .disposed(by: bag)
        viewModel.headerTapped(headerTapRecognizer.rx.tap.asObservable())
            .disposed(by: bag)
        
        viewModel.addedPlaces
            .drive(
                tableView.rx.items(
                    cellIdentifier: EditPlaceCell.identifier,
                    cellType: EditPlaceCell.self
                )
            ) { [unowned self] i, item, cell in
                cell.configure(for: item, menu: self.viewModel.menu(for: item))
                
                cell.startPicker.rx.controlEvent(.editingDidEnd)
                    .map { [unowned cell] in cell.startPicker.date }
                    .filter { $0 != item.visitedPlace.start }
                    .subscribe(onNext: { d in self.viewModel.setStart(of: item, to: d) })
                    .disposed(by: cell.bag)
                
                cell.endPicker.rx.controlEvent(.editingDidEnd)
                    .map { [unowned cell] in cell.endPicker.date }
                    .filter { $0 != item.visitedPlace.end }
                    .subscribe(onNext: { d in self.viewModel.setEnd(of: item, to: d) })
                    .disposed(by: cell.bag)
                
                self.viewModel.loadingImagesFor
                    .map { $0.contains(item.visitedPlace.id) }
                    .distinctUntilChanged()
                    .drive(cell.isLoading)
                    .disposed(by: cell.bag)

                self.viewModel.expandedItems
                    .map { $0.contains(item.visitedPlace.id) }
                    .drive(cell.cellExpanded)
                    .disposed(by: cell.bag)

                cell.cellTapRecognizer.rx.tap
                    .withLatestFrom(self.viewModel.expandedItems)
                    .map { $0.contains(item.visitedPlace.id) }
                    .subscribe(onNext: { self.viewModel.set(item, expanded: !$0) })
                    .disposed(by: cell.bag)
                
                cell.imageTapRecognizer.rx.tap
                    .subscribe(
                        onNext: { [unowned cell] in
                            self.viewModel.imageTapped(item, view: cell.picturePreview)
                        }
                    )
                    .disposed(by: cell.bag)
            }
            .disposed(by: bag)
        
        viewModel.expandedItems.asObservable()
            .subscribe(onNext: { [unowned self] _ in self.tableView.reloadData() } )
            .disposed(by: bag)
    }
    
    
    @objc func didEndEditing(sender: UIDatePicker) {
        print("TEST: End \(sender.date)")
    }
    
    @objc func didChangeValue(sender: UIDatePicker) {
        print("TEST: Value \(sender.date)")
    }
    
}
