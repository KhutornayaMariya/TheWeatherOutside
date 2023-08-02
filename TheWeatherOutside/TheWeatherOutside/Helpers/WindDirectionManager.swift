//
//  WindDirectionManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 02.01.23.
//

import Foundation

struct WindDirectionManager {

    private static let directions = ["NORTH".localized,
                                     "NORTHEAST".localized,
                                     "EAST".localized,
                                     "SOUTHEAST".localized,
                                     "SOUTH".localized,
                                     "SOUTHWEST".localized,
                                     "WEST".localized,
                                     "NORTHWEST".localized]
    
    static func windDirection(from degrees : Double) -> String {
        directions[Int((degrees + 11.25)/45) % 8]
    }
}
