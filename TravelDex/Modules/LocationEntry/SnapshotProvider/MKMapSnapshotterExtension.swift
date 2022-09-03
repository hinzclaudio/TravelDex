//
//  MKMapSnapshotterExtension.swift
//  TravelDex
//
//  Created by Claudio Hinz on 27.08.22.
//

import Foundation
import MapKit
import RxSwift



extension MKMapSnapshotter: SnapshotProviderType {
    
    var snapshot: Observable<UIImage?> {
        Observable.create { observer in
            self.start(completionHandler: { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot.image)
                    observer.onCompleted()
                } else {
                    assertionFailure("Something's missing...")
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create {
                self.cancel()
            }
        }
    }
    
}
