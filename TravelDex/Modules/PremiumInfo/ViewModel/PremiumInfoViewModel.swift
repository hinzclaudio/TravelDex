//
//  PremiumInfoViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.09.22.
//

import Foundation
import RxSwift
import RxCocoa



class PremiumInfoViewModel: PremiumInfoViewModelType {
    
    lazy var premiumFeatureInfos: Driver<[String]> = {
        .just([
            Localizable.premiumInfoContent1,
            Localizable.premiumInfoContent2,
            Localizable.premiumInfoContent3,
            Localizable.premiumInfoContent4
        ])
    }()
    
}
