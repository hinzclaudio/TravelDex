//
//  TripsListController_TableDelegate.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 22.08.22.
//

import UIKit
import RxSwift



extension TripsListController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                let trip: Trip? = try! self?.tableView.rx.model(at: indexPath)
                if let trip = trip {
                    return self?.viewModel.preview(for: trip)
                } else {
                    return nil
                }
            },
            actionProvider: { [weak self] actions in
                let editAction = UIAction(
                    title: "Edit",
                    image: SFSymbol.pencil.image,
                    handler: { [weak self] _ in self?.editingIP.onNext(indexPath) }
                )
                let deleteAction = UIAction(
                    title: "Delete",
                    image: SFSymbol.trash.image,
                    attributes: .destructive,
                    handler: { _ in self?.deletionIP.onNext(indexPath) }
                )
                return UIMenu(
                    title: "Menu",
                    children: [editAction, deleteAction]
                )
            }
        )
    }

}
