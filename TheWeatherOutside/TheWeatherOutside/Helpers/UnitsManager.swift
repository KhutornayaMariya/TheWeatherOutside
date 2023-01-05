//
//  UnitsManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 04.01.23.
//

import Foundation

protocol UnitsManagerProtocol {
    func convertTempToImperial(_ temp: Double) -> Int16
    func convertSpeedToImperial(_ speed: Double) -> Int16
}

final class UnitsManager: UnitsManagerProtocol {
    func convertTempToImperial(_ temp: Double) -> Int16 {
        let celsius = Measurement(value: temp, unit: UnitTemperature.celsius)
        let fahrenheit = celsius.converted(to: UnitTemperature.fahrenheit).value.rounded(.toNearestOrEven)
        return Int16(fahrenheit)
    }
    
    func convertSpeedToImperial(_ speed: Double) -> Int16 {
        let kilometersPerHour = Measurement(value: speed, unit: UnitSpeed.kilometersPerHour)
        let milesPerHour = kilometersPerHour.converted(to: UnitSpeed.milesPerHour).value.rounded(.toNearestOrEven)
        return Int16(milesPerHour)
    }
}
