//
//  TripsListViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class TripsListViewModel: NSObject, TripsListViewModelType {
    
    weak var coordinator: AppCoordinatorType?
    
    typealias Dependencies = HasTripsStore & HasSKStore
    internal let dependencies: Dependencies
    internal let bag = DisposeBag()
    
    init(dependencies: Dependencies, coordinator: AppCoordinatorType) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        super.init()
    }
    
    
    
    // MARK: - Input
    public let storeTapped = PublishRelay<Void>()
    public let mapTapped = PublishRelay<Void>()
    public let addTapped = PublishRelay<Void>()
    public let importTapped = PublishRelay<Void>()
    public let exportTrip = PublishRelay<Trip>()
    public let shareTrip = PublishRelay<Trip>()
    public let selectTrip = PublishRelay<Trip>()
    public let deleteTrip = PublishRelay<Trip>()
    public let editTrip = PublishRelay<Trip>()
    public let pickColorForTrip = PublishRelay<Trip>()
    
    public func onDidLoad() {
        storeTapped
            .subscribe(onNext: { [weak self] in self?.coordinator?.selectStore() })
            .disposed(by: bag)
        
        mapTapped
            .subscribe(onNext: { [weak self] in self?.coordinator?.displayMap() })
            .disposed(by: bag)
        
        coordinator?
            .goToAddTrip(when: addTapped.asObservable())
            .disposed(by: bag)
       
        coordinator?.goToImportTrip(self, when: importTapped.asObservable())
            .disposed(by: bag)
        
        let exportFile = exportTrip
            .withLatestFrom(dependencies.skStore.premiumFeaturesEnabled) { ($0, $1) }
            .flatMapLatest { [unowned self] trip, premiumEnabled in
                if premiumEnabled {
                    return self.dependencies.tripsStore
                        .export(trip)
                        .materialize()
                } else {
                    return Observable
                        .create { observer in
                            observer.onError(PremiumStoreError.premiumFeaturesUnavailable)
                            return Disposables.create()
                        }
                        .materialize()
                }
            }
            .do(onNext: { [weak self] in self?._errors.accept($0.error) })
            .compactMap(\.element)
        coordinator?.share(exportAt: exportFile)
            .disposed(by: bag)
                
        shareTrip
            .subscribe(onNext: { [weak self] in self?.coordinator?.shareOverview(forTrip: $0) })
            .disposed(by: bag)
                
        selectTrip
                .subscribe(onNext: { [weak self] in self?.coordinator?.select($0) })
                .disposed(by: bag)
                
        editTrip
            .subscribe(onNext: { [weak self] in self?.coordinator?.edit($0) })
            .disposed(by: bag)
        
        coordinator?.pickColor(for: pickColorForTrip.asObservable())
            .disposed(by: bag)
                
        dependencies.tripsStore.delete(deleteTrip.asObservable())
            .disposed(by: bag)
    }
    
    
    // MARK: - Output
    public func trips(for search: Observable<String>) -> Driver<[Trip]> {
        search
            .flatMapLatest { [unowned self] query in
                self.dependencies.tripsStore.trips(forSearch: query)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    public lazy var tripsIsEmpty: Driver<Bool> = {
        dependencies.tripsStore.trips(forSearch: "")
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
    }()
    
    internal let _errors = BehaviorRelay<Error?>(value: nil)
    public lazy var errorController: Driver<UIAlertController> = {
        _errors
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .map(InfoManager.defaultErrorInfo(for:))
    }()
    
}
