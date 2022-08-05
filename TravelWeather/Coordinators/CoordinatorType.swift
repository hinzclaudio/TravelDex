//
//  CoordinatorType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import UIKit



protocol CoordinatorType: AnyObject {
    
    var childCoordinators: [CoordinatorType] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    
}
