//
//  AddPlacesController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources



class AddPlacesController: UIViewController {
    
    let viewModel: AddPlacesViewModelType
    let bag = DisposeBag()
    
    // MARK: - Views
    let mapButton = UIBarButtonItem()
    let addButton = UIBarButtonItem(systemItem: .add)
    
    let headerView = TripCell()
    let tableView = UITableView()
    let addLocationsLabel = UILabel()
    
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
        view.addSubview(addLocationsLabel)
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
        
        addLocationsLabel.styleText()
        addLocationsLabel.textAlignment = .center
        addLocationsLabel.text = "You did not add any locations yet. Add a location by tapping the plus icon!"
    }
    
    private func setAutoLayout() {
        headerView.autoMatch(.width, to: .width, of: view)
        
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        addLocationsLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 3 * Sizes.defaultMargin)
        addLocationsLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 3 * Sizes.defaultMargin)
        addLocationsLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 3 * Sizes.defaultMargin)
        addLocationsLabel.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 3 * Sizes.defaultMargin)
    }
    
    private func setupBinding() {
        viewModel.mapButton(mapButton.rx.tap.asObservable())
            .disposed(by: bag)
        viewModel
            .addLocation(addButton.rx.tap.asObservable())
            .disposed(by: bag)
        
        viewModel.trip
            .drive(onNext: { [unowned self] trip in
                self.headerView.configure(for: trip)
                self.headerView.layoutIfNeeded()
            })
            .disposed(by: bag)
        viewModel.headerTapped(headerTapRecognizer.rx.tap.asObservable())
            .disposed(by: bag)
        
        let tableDataSource = RxTableViewSectionedAnimatedDataSource<AddedPlaceSection>(
            configureCell: { [unowned self] dataSource, tableView, indexPath, vm in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: EditPlaceCell.identifier,
                    for: indexPath
                ) as! EditPlaceCell
                
                cell.configure(
                    for: vm,
                    menu: self.viewModel.menu(for: vm.item)
                )
                
                cell.startPicker.rx.controlEvent(.editingDidEnd)
                    .map { [unowned cell] in cell.startPicker.date }
                    .filter { $0 != vm.item.visitedPlace.start }
                    .subscribe(onNext: { d in self.viewModel.setStart(of: vm.item, to: d) })
                    .disposed(by: cell.bag)
                
                cell.endPicker.rx.controlEvent(.editingDidEnd)
                    .map { [unowned cell] in cell.endPicker.date }
                    .filter { $0 != vm.item.visitedPlace.end }
                    .subscribe(onNext: { d in self.viewModel.setEnd(of: vm.item, to: d) })
                    .disposed(by: cell.bag)
                
                self.viewModel.loadingImagesFor
                    .map { $0.contains(vm.item.visitedPlace.id) }
                    .distinctUntilChanged()
                    .drive(cell.isLoading)
                    .disposed(by: cell.bag)

                cell.cellTapRecognizer.rx.tap
                    .subscribe(onNext: { self.viewModel.set(vm.item, expanded: !vm.expanded) })
                    .disposed(by: cell.bag)
                
                cell.imageTapRecognizer.rx.tap
                    .subscribe(
                        onNext: { [unowned cell] in
                            self.viewModel.imageTapped(vm.item, view: cell.picturePreview)
                        }
                    )
                    .disposed(by: cell.bag)
                
                return cell
            }
        )
        
        viewModel.addedPlaces
            .drive(tableView.rx.items(dataSource: tableDataSource))
            .disposed(by: bag)
        
        let addedPlacesAvailable = viewModel.addedPlaces
            .map { sections in sections.reduce(into: 0, { $0 += $1.items.count }) }
            .map { $0 > 0 }
            .distinctUntilChanged()
        addedPlacesAvailable
            .map { !$0 }
            .drive(tableView.rx.isHidden)
            .disposed(by: bag)
        addedPlacesAvailable
            .drive(addLocationsLabel.rx.isHidden)
            .disposed(by: bag)
    }
    
}
