//
//  WeatherConditionImageManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import Foundation

final class WeatherConditionImageManager {
    func skyConditionImage(rain: Double, snow: Double, cloudCover: Int16) -> String {
        if snow == 0 && rain == 0 && cloudCover < 10 {
            return "sunny"
        } else if rain != 0 && cloudCover < 10 {
            return "sun_rain"
        } else if rain != 0 {
            return "rain"
        }  else if snow != 0 {
            return "snow"
        } else if cloudCover > 70 {
            return "cloudy"
        } else {
            return "sun_cloud"
        }
    }
}
