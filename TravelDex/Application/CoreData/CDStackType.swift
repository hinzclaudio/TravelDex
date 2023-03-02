//
//  CDStack.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.08.22.
//

import Foundation
import CoreData



protocol CDStackType {
    
    var saveContext: NSManagedObjectContext { get }
    var reducerContext: NSManagedObjectContext { get }
    
    func save()
    func dispatch(_ action: CDAction)
    
}
