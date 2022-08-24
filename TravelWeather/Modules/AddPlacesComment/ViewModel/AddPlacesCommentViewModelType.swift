//
//  AddPlacesCommentViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 24.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol AddPlacesCommentViewModelType {
    
    // MARK: - Input
    var comment: PublishSubject<String> { get }
    func confirm(_ tapped: Observable<Void>) -> Disposable
    
    
    // MARK: - Output
    var addedPlace: Driver<AddedPlaceItem> { get }
    
}
