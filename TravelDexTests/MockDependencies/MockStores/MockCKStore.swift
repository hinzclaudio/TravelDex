//
//  MockCKStore.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 11.03.23.
//

import Foundation
import RxSwift
import RxCocoa
@testable import TravelDex



class MockCKStore: CKStoreType {
    
    public let _shareInfo = BehaviorRelay<[CKShareInfo]?>(value: nil)
    public lazy var shareInfo: Observable<[CKShareInfo]> = _shareInfo
        .compactMap({ $0 })
        .distinctUntilChanged()
        .share()
    
}
