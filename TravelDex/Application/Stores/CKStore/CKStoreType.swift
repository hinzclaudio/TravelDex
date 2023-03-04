//
//  CKStoreType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.03.23.
//

import Foundation
import CloudKit
import CoreData
import RxSwift



protocol CKStoreType {
    
    var shareInfo: Observable<[CKShareInfo]> { get }
    
}
