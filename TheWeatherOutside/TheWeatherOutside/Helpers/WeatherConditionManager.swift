//
//  WeatherConditionImageManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import Foundation

struct WeatherConditionManager {

    static func skyConditionImage(rain: Double, snow: Double, cloudCover: Int16, isDay: Bool) -> String {
        if snow == 0 && rain == 0 && cloudCover < 10 {
            return isDay ? "sunny" : "moon"
        } else if rain != 0 && cloudCover < 10 {
            return isDay ? "sun_rain" : "moon"
        } else if rain != 0 {
            return "rain"
        }  else if snow != 0 {
            return "snow"
        } else if cloudCover > 70 {
            return "cloudy"
        }
        return isDay ? "sun_cloud" : "moon"
    }
    
    static func precipitationAmount(rain: Double, snow: Double) -> String {
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
    
    static func precipitation(rain: Double, snow: Double, cloudCover: Int16, isDay: Bool) -> WeatherParameterViewModel {
        let parameterName = "PRECIPITATION_TITLE".localized.capitalizedSentence
        let value = precipitationAmount(rain: rain, snow: snow)
        let image = skyConditionImage(rain: rain, snow: snow, cloudCover: cloudCover, isDay: isDay)
        return .init(parameterName: parameterName,
                     value: value,
                     imageName: image)
    }
}
