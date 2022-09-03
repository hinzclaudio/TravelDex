//
//  CDHelperExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation



extension NSSet {
    func asArray<T>(of type: T.Type) -> Array<T>? {
        allObjects as? [T]
    }
    
}



extension NSOrderedSet {
    func asArray<T>(of type: T.Type) -> Array<T>? {
        array as? Array<T>
    }
    
}
