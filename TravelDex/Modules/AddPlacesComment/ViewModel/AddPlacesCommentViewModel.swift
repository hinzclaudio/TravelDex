//
//  AddPlacesCommentViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 24.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class AddPlacesCommentViewModel: AddPlacesCommentViewModelType {
    
    typealias Dependencies = HasPlacesStore
    private let dependencies: Dependencies
    weak var coordinator: AppCoordinatorType?
    
    init(dependencies: Dependencies, item: AddedPlaceItem, coordinator: AppCoordinatorType) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        self.addedPlace = dependencies.placesStore
            .place(identifiedBy: .just(item.visitedPlace.id))
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: item)
    }
    
    
    // MARK: - Input
    let comment = PublishSubject<String?>()
    
    func confirm(_ tapped: Observable<Void>) -> Disposable {
        tapped
            .withLatestFrom(comment.nilIfEmpty.startWith(nil))
            .withLatestFrom(addedPlace) { c, place in
                place.visitedPlace.cloneBuilder()
                    .with(text: c)
                    .build()!
            }
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.dismissModalController()
                self?.dependencies.placesStore.update($0)
            })
    }
    
    
    // MARK: - Output
    let addedPlace: Driver<AddedPlaceItem>
    
}
