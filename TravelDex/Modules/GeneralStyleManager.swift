//
//  GeneralStyleManager.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class GeneralStyleManager {
    
    static func largeNavigationBarTitleAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Asset.TDColors.text.color
        ]
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Asset.TDColors.text.color
        ]
        return appearance
    }
    
    static func style(_ navigationBar: UINavigationBar) {
        navigationBar.standardAppearance = largeNavigationBarTitleAppearance()
        navigationBar.tintColor = Asset.TDColors.icon.color
    }
    
}
