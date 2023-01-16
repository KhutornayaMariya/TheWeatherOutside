//
//  UserDefaultsManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 09.01.23.
//

import Foundation

enum UserDefaultsKeys: String {
    case locationDenied = "locationDenied"
    case units = "units"
}

enum Units: String {
    case metric = "metric"
    case imperial = "imperial"
}

final class UserDefaultsManager {
    
    static let defaultManager = UserDefaultsManager()

    func isImpericUnits() -> Bool {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.units.rawValue) == Units.imperial.rawValue
    }
}
