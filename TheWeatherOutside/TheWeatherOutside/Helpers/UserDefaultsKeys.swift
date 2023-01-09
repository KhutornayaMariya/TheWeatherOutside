//
//  UserDefaultsKeys.swift
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
