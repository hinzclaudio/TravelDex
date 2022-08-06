//
//  GeneralStyleManager.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class GeneralStyleManager {
    
    static func largeNavigationBarTitleAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Colors.navBarColor
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Colors.defaultWhite
        ]
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Colors.defaultWhite
        ]
        return appearance
    }
    
    static func style(_ navigationBar: UINavigationBar) {
        navigationBar.standardAppearance = largeNavigationBarTitleAppearance()
        navigationBar.tintColor = Colors.lightGreen
    }
    
    static func styleModal(_ navigationBar: UINavigationBar) {
        navigationBar.standardAppearance = largeNavigationBarTitleAppearance()
        navigationBar.tintColor = Colors.defaultWhite
        navigationBar.backgroundColor = Colors.navBarColor
    }
    
}
