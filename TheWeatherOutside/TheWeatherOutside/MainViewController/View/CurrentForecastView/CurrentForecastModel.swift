//
//  CurrentForecastModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 09.01.23.
//

import Foundation

struct CurrentForecastModel {
    private let dateManager: DateManagerProtocol = DateManager()
    
    let feelsLikeTemp: String
    let currentTemp: String
    let description: String
    let date: String
    let sunriseTime: String
    let sunsetTime: String
    let windSpeed: String
    let cloudCover: String
    let precipitation: Precipitation
    
    init(currentForecast data: Current, timeZone: String) {
        self.description = data.weatherDesc?.capitalizedSentence ?? ""
        self.cloudCover = String(data.cloudCover)
        self.precipitation = Precipitation(for: data)
        
        if let date = data.date,
           let sunriseTime = data.sunrise,
           let sunsetTime = data.sunset {
            self.date = dateManager.convert(date, to: timeZone, with: "E, d MMMM yyyy")
            self.sunriseTime = dateManager.convert(sunriseTime, to: timeZone, with: "HH:mm")
            self.sunsetTime = dateManager.convert(sunsetTime, to: timeZone, with: "HH:mm")
        } else {
            self.date = ""
            self.sunriseTime = ""
            self.sunsetTime = ""
        }
        
        if UserDefaults.standard.string(forKey: UserDefaultsKeys.units.rawValue) == Units.imperial.rawValue {
            self.feelsLikeTemp = String(data.feelsLikeImp)
            self.currentTemp = String(data.temperatureImp)
            self.windSpeed = String(data.windSpeedImp) + "SPEED_IMP".localized
        } else {
            self.feelsLikeTemp = String(data.feelsLike)
            self.currentTemp = String(data.temperature)
            self.windSpeed = String(data.windSpeed) + "SPEED_METRIC".localized
        }
    }
}

extension CurrentForecastModel {
    struct Precipitation {
        enum precipitationType {
            case rain
            case snow
            case rainless
        }
        
        let type: precipitationType
        let amount: String
        
        init(for data: Current) {
            if data.rain != 0 && data.rain > data.snow {
                self.type = .rain
                self.amount = String(data.rain)
            } else if data.snow > data.rain {
                self.type = .snow
                self.amount = String(data.snow)
            } else {
                self.type = .rainless
                self.amount = String(data.snow)
            }
        }
    }
}
