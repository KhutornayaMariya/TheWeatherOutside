//
//  DailyForecastModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import Foundation

struct DailyForecastModel {
    private let dateManager: DateManagerProtocol = DateManager()
    private let imageManager = WeatherConditionImageManager()

    let date: String
    let temperature: String
    let description: String
    let imageName: String
    let amountOfPrecipitation: String
    
    init(data: Daily, timeZone: String) {
        self.imageName = imageManager.skyConditionImage(rain: data.rain, snow: data.snow, cloudCover: data.cloudCover)
        self.description = data.weatherDesc?.capitalizedSentence ?? ""
        
        if let date = data.date {
            self.date = dateManager.convert(date, to: timeZone, with: "dd/MM")
        } else {
            self.date = ""
        }
        if UserDefaults.standard.string(forKey: UserDefaultsKeys.units.rawValue) == Units.imperial.rawValue {
            self.temperature = "\(String(data.tempMinImp))/\(String(data.tempMaxImp))°"
        } else {
            self.temperature =  "\(String(data.tempMin))/\(String(data.tempMax))°"
        }
        if data.rain != 0 {
            self.amountOfPrecipitation = "\(String(data.rain)) \("PRECIPITATION".localized)"
        } else if data.snow != 0 {
            self.amountOfPrecipitation = "\(String(data.snow)) \("PRECIPITATION".localized)"
        } else {
            self.amountOfPrecipitation = "0 \("PRECIPITATION".localized)"
        }
    }
}
