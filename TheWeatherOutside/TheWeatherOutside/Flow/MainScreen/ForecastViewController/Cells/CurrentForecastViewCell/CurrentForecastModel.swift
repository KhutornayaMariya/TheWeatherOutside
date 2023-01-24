//
//  CurrentForecastModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 09.01.23.
//

import Foundation

struct CurrentForecastModel {
    
    struct Precipitation {
        enum precipitationType {
            case rain
            case snow
            case rainless
        }
        
        let type: precipitationType
        let amount: String
    }
    
    let feelsLikeTemp: String
    let currentTemp: String
    let description: String
    let date: String
    let sunriseTime: String
    let sunsetTime: String
    let windSpeed: String
    let cloudCover: String
    let precipitation: Precipitation
}
