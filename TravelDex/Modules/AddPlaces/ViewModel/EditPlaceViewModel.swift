//
//  EditPlaceViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 26.08.22.
//

import Foundation
import RxDataSources



struct EditPlaceViewModel: Equatable {
    let item: AddedPlaceItem
    let expanded: Bool
}



// MARK: - RxDataSource
extension EditPlaceViewModel: IdentifiableType {
    
    typealias Identity = VisitedPlaceID
    
    var identity: VisitedPlaceID {
        item.visitedPlace.id
    }
    
}

struct AddedPlaceSection: AnimatableSectionModelType {
    
    typealias Item = EditPlaceViewModel
    typealias Identity = UUID
    
    let identity: UUID
    var items: [EditPlaceViewModel]
    
    init(id: UUID, items: [EditPlaceViewModel]) {
        self.identity = id
        self.items = items
    }
    
    init(original: AddedPlaceSection, items: [EditPlaceViewModel]) {
        self.identity = original.identity
        self.items = items
    }
}
