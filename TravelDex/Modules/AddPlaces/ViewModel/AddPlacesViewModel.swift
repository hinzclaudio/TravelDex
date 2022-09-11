//
//  AddPlacesViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI



class AddPlacesViewModel: AddPlacesViewModelType {
    
    weak var coordinator: AppCoordinatorType?

    typealias Dependencies = HasTripsStore & HasPlacesStore
    let dependencies: Dependencies
    let initialTrip: Trip
    
    init(dependencies: Dependencies, trip: Trip) {
        self.dependencies = dependencies
        self.initialTrip = trip
    }
    
    
    // MARK: - Input
    func mapButton(_ tapped: Observable<Void>) -> Disposable {
        tapped.withLatestFrom(trip)
            .subscribe(onNext: { [weak self] trip in self?.coordinator?.displayMap(for: trip) })
    }
    
    func addLocation(_ tapped: Observable<Void>) -> Disposable {
        coordinator?
            .searchLocation(for: tapped.withLatestFrom(trip)) ?? Disposables.create()
    }
    
    func setStart(of item: AddedPlaceItem, to date: Date) {
        let newPlace = item.visitedPlace.cloneBuilder()
            .with(start: date)
            .build()!
        dependencies.placesStore.update(newPlace)
    }
    
    func setEnd(of item: AddedPlaceItem, to date: Date) {
        let newPlace = item.visitedPlace.cloneBuilder()
            .with(end: date)
            .build()!
        dependencies.placesStore.update(newPlace)
    }
    
    func set(_ item: AddedPlaceItem, expanded: Bool) {
        var newItems = _expandedItems.value
        if expanded {
            newItems.insert(item.visitedPlace.id)
        } else {
            newItems.remove(item.visitedPlace.id)
        }
        _expandedItems.accept(newItems)
    }
    
    func imageTapped(_ item: AddedPlaceItem, view: UIImageView) {
        if let imgData = item.visitedPlace.picture {
            let img = UIImage(data: imgData)
            coordinator?.photoViewer(from: view, image: img)
        } else {
            addOrChangeImage(to: item)
        }
    }
    
    
    // MARK: - Output
    lazy var trip: Driver<Trip> = {
        dependencies.tripsStore
            .trip(identifiedBy: .just(initialTrip.id))
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: initialTrip)
    }()
    
    lazy var addedPlaces: Driver<[AddedPlaceSection]> = {
        let placesDriver: Driver<[AddedPlaceItem]> = dependencies.placesStore
                .places(for: .just(initialTrip.id))
                .asDriver(onErrorJustReturn: [])
        let expandedDriver: Driver<Set<VisitedPlaceID>> = _expandedItems
            .asDriver()
        
        return Driver.combineLatest(placesDriver, expandedDriver)
            .map { [unowned self] places, expanded -> [AddedPlaceSection] in
                let viewModels = places
                    .map { item -> EditPlaceViewModel in
                        let isExpanded = expanded.contains(item.visitedPlace.id)
                        return EditPlaceViewModel(item: item, expanded: isExpanded)
                    }
                return [AddedPlaceSection(id: self.initialTrip.id, items: viewModels)]
            }
    }()
    
    let _expandedItems = BehaviorRelay<Set<VisitedPlaceID>>(value: [])
    
    let _loadingImagesFor = BehaviorRelay<Set<VisitedPlaceID>>(value: [])
    lazy var loadingImagesFor: Driver<Set<VisitedPlaceID>> = {
        _loadingImagesFor.asDriver()
    }()
    
    
    // MARK: - Menu
    func menu(for item: AddedPlaceItem) -> UIMenu {
        
        let imgMenu: UIMenu
        
        if item.visitedPlace.picture != nil {
            let updateImgAction = UIAction(
                title: Localizable.actionChangeImage,
                image: SFSymbol.squareAndPencil.image
            ) { [weak self] _ in
                self?.addOrChangeImage(to: item)
            }
            let delImgAction = UIAction(
                title: Localizable.actionDeleteImage,
                image: SFSymbol.trash.image,
                attributes: .destructive
            ) { [weak self] _ in
                self?.deleteImage(of: item)
            }
            imgMenu = UIMenu(
                title: Localizable.menuImageTitle,
                options: .displayInline,
                children: [updateImgAction, delImgAction]
            )
        } else {
            let addImgAction = UIAction(
                title: Localizable.actionAddImage,
                image: SFSymbol.plus.image
            ) { [weak self] _ in
                self?.addOrChangeImage(to: item)
            }
            imgMenu = UIMenu(
                title: Localizable.menuImageTitle,
                options: .displayInline,
                children: [addImgAction]
            )
        }
        
        let showOnMapAction = UIAction(
            title: Localizable.actionShowOnMap,
            image: SFSymbol.map.image
        ) { [weak self] _ in
            self?.display(item)
        }
        let editTextAction = UIAction(
            title: Localizable.actionEditComment,
            image: SFSymbol.pencil.image
        ) { [weak self] _ in
            self?.coordinator?.comment(on: item)
        }
        let delAction = UIAction(
            title: Localizable.actionDelete,
            image: SFSymbol.trash.image,
            attributes: .destructive
        ) { [weak self] _ in
            self?.delete(item)
        }
        return UIMenu(
            title: item.location.name,
            children: [imgMenu, showOnMapAction, editTextAction, delAction]
        )
    }
    
    let pickingForItem = BehaviorRelay<AddedPlaceItem?>(value: nil)
    private func addOrChangeImage(to item: AddedPlaceItem) {
        pickingForItem.accept(item)
        coordinator?.pickPhoto(self, for: item.visitedPlace)
    }
    
    private func deleteImage(of item: AddedPlaceItem) {
        let updatedPlace = item.visitedPlace.cloneBuilder()
            .with(picture: nil)
            .build()!
        dependencies.placesStore.update(updatedPlace)
    }
    
    private func display(_ item: AddedPlaceItem) {
        coordinator?.displayMap(for: item.visitedPlace)
    }
    
    private func delete(_ item: AddedPlaceItem) {
        set(item, expanded: false)
        dependencies.placesStore.delete(item.visitedPlace)
    }
    
}



// MARK: - PhotoPickerViewModel
extension AddPlacesViewModel: PhotoPickerViewModelType {
    
    var configuration: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.selection = .default
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        return config
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        defer { picker.dismiss(animated: true) }

        guard let place = pickingForItem.value?.visitedPlace, let result = results.first
        else { return }
        
        var loading = _loadingImagesFor.value
        loading.insert(place.id)
        _loadingImagesFor.accept(loading)
        
        result
            .itemProvider
            .loadObject(ofClass: UIImage.self) { [weak self] object, error in
                var loading = self?._loadingImagesFor.value ?? []
                loading.remove(place.id)
                self?._loadingImagesFor.accept(loading)
                
                if let error = error {
                    assertionFailure("Error: \(error)")
                } else if let img = object as? UIImage {
                    let updatedPlace = place.cloneBuilder()
                        .with(picture: img.jpegData(compressionQuality: 0.33))
                        .build()!
                    self?.dependencies.placesStore.update(updatedPlace)
                } else {
                    assertionFailure("Something's wrong.")
                }
            }
        
    }
    
}
