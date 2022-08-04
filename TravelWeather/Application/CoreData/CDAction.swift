//
//  CDAction.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 04.08.22.
//

import Foundation
import CoreData



protocol CDAction {
    func execute(in context: NSManagedObjectContext)
}
