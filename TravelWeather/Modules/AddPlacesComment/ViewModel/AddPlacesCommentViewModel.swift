//
//  AddPlacesCommentViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 24.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class AddPlacesCommentViewModel: AddPlacesCommentViewModelType {
    
    typealias Dependencies = HasPlacesStore
    private let dependencies: Dependencies
    weak var coordinator: AppCoordinator?
    
    init(dependencies: Dependencies, item: AddedPlaceItem) {
        self.dependencies = dependencies
        self.addedPlace = dependencies.placesStore
            .place(identifiedBy: .just(item.visitedPlace.id))
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: item)
    }
    
    
    // MARK: - Input
    let comment = PublishSubject<String?>()
    
    func confirm(_ tapped: Observable<Void>) -> Disposable {
        tapped
            .debug("TAP")
            .withLatestFrom(comment.nilIfEmpty)
            .debug("COM")
            .withLatestFrom(addedPlace) { c, place in
                place.visitedPlace.cloneBuilder()
                    .with(text: c)
                    .build()!
            }
            .debug("PLA")
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.modalController?.dismiss(animated: true)
                self?.dependencies.placesStore.update($0)
            })
    }
    
    
    // MARK: - Output
    let addedPlace: Driver<AddedPlaceItem>
    
}
