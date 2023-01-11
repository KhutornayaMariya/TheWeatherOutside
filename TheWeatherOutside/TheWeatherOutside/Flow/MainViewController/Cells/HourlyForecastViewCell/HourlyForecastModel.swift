//
//  HourlyForecastModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import Foundation

struct HourlyForecastModel {
    private let dateManager: DateManagerProtocol = DateManager()
    private let imageManager = WeatherConditionImageManager()

    let time: String
    let temperature: String
    let imageName: String
    
    init(data: Hourly, timeZone: String) {
        if let date = data.date {
            self.time = dateManager.convert(date, to: timeZone, with: "HH:mm")
        } else {
            self.time = ""
        }
        
        if UserDefaults.standard.string(forKey: UserDefaultsKeys.units.rawValue) == Units.imperial.rawValue {
            self.temperature = String(data.temperatureImp) + "°"
        } else {
            self.temperature =  String(data.temperature) + "°"
        }
        self.imageName = imageManager.skyConditionImage(rain: data.rain, snow: data.snow, cloudCover: data.cloudCover)
    }
}
