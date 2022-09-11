//
//  PremiumInfoViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.09.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol PremiumInfoViewModelType {
    var premiumFeatureInfos: Driver<[String]> { get }
}
