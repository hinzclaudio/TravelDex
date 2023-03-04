//
//  TripsListController_TableDelegate.swift
//  TravelDex
//
//  Created by Claudio Hinz on 22.08.22.
//

import UIKit
import RxSwift
import RxCocoa



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
                let exportAction = UIAction(
                    title: Localizable.actionExportTrip,
                    image: SFSymbol.export.image,
                    handler: { [weak self] _ in self?.exportIP.accept(indexPath) }
                )
                let editTextAction = UIAction(
                    title: Localizable.actionEdit,
                    image: SFSymbol.pencil.image,
                    handler: { [weak self] _ in self?.editingIP.accept(indexPath) }
                )
                let editColortAction = UIAction(
                    title: Localizable.actionPickColor,
                    image: SFSymbol.paintpalette.image,
                    handler: { [weak self] _ in self?.pickingColorIP.accept(indexPath) }
                )
                let deleteAction = UIAction(
                    title: Localizable.actionDelete,
                    image: SFSymbol.trash.image,
                    attributes: .destructive,
                    handler: { _ in self?.deletionIP.accept(indexPath) }
                )
                return UIMenu(
                    title: Localizable.menuTitle,
                    children: [exportAction, editTextAction, editColortAction, deleteAction]
                )
            }
        )
    }

}
