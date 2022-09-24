//
//  ResultExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 25.09.22.
//

import Foundation
import RxSwift



extension Result where Failure == Error {
    var asObservable: Observable<Success> {
        Observable.create { observer in
            switch self {
            case .success(let success):
                observer.onNext(success)
            case .failure(let error):
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
