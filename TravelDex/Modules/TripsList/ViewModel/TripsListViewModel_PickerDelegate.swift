//
//  TripsListViewModel_PickerDelegate.swift
//  TravelDex
//
//  Created by Claudio Hinz on 25.09.22.
//

import UIKit
import RxSwift



extension TripsListViewModel: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedFileURL = urls.first else { return }
        let importedTrip = dependencies.tripsStore
            .importData(from: pickedFileURL)
            .materialize()
            .do(onNext: { [weak self] in self?._errors.accept($0.error) })
            .compactMap { $0.element }
        let _ = select(importedTrip)
    }
    
}
