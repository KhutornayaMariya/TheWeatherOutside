//
//  DateManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import Foundation

struct DateManager {
    static func convert(_ date: Date, to timeZone: String, with dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = TimeZone(identifier: timeZone)
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: date)
    }
}
