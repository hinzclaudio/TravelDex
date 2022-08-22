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
            identifier: NSNumber(value: Int64(indexPath.row)),
            previewProvider: nil,
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
    
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        makeTargetedPreview(for: configuration)
    }
    
    private func makeTargetedPreview(for config: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = config.identifier as? NSNumber,
              let cell = tableView.cellForRow(at: IndexPath(row: identifier.intValue, section: 0)),
              let tripCell = cell as? TripsListTableCell
        else {
            assertionFailure("Something's missing...")
            return nil
        }

        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear

        return UITargetedPreview(view: tripCell.view.containerView, parameters: parameters)
    }

}
