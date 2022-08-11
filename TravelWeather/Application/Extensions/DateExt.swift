//
//  DateExt.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 11.08.22.
//

import Foundation



extension Date {
    
    var dayMonthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d. MMMM yyyy"
        formatter.locale = NSLocale.current
        return formatter.string(from: self)
    }
    
}
