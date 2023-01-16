//
//  WeatherConditionImageManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import Foundation

final class WeatherConditionManager {
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
    
    func precipitationAmount(rain: Double, snow: Double) -> String {
        if rain != 0 && rain > snow {
            return .init("\(String(rain)) \("PRECIPITATION".localized)")
        }
        else if snow > rain {
            return .init("\(String(snow)) \("PRECIPITATION".localized)")
        }
        else {
            return .init("0 \("PRECIPITATION".localized)")
        }
    }
}
