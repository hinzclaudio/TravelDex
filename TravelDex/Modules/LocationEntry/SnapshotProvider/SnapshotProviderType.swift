//
//  SnapshotProviderType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 27.08.22.
//

import Foundation
import RxSwift



protocol SnapshotProviderType {
    var snapshot: Observable<UIImage?> { get }
}
