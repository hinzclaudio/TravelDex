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



extension CoordinatorType {
    
    func store(coordinator: CoordinatorType) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: CoordinatorType) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    @discardableResult
    func presentModally(_ viewController: UIViewController) -> UIViewController {
        let modalContainer = ModalNavigationContainer(rootViewController: viewController)
        GeneralStyleManager.styleModal(modalContainer.navigationBar)
        modalContainer.modalPresentationStyle = .automatic
        navigationController.present(modalContainer, animated: true)
        return modalContainer
    }
    
    @discardableResult
    func presentBottomSheet(_ viewController: UIViewController) -> UIViewController {
        let modalContainer = ModalNavigationContainer(rootViewController: viewController)
        GeneralStyleManager.styleModal(modalContainer.navigationBar)
        modalContainer.modalPresentationStyle = .pageSheet
        if let sheet = modalContainer.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController.present(modalContainer, animated: true)
        return modalContainer
    }
    
}
