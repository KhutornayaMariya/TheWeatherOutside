//
//  DailyViewModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import Foundation

struct DailyViewModel {
    struct DailyForecastItem {
        let date: String
        let timeOfDay: [TimeOfDayItem]
        let sunAndMoon: SunAndMoon
    }
    
    let locationTitle: String
    var dailyForecast: [DailyForecastItem]
}

struct SunAndMoon {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let daylength: String
    let nightlength: String
}

struct TimeOfDayItem {
    let title: String
    let temperature: String
    let imageName: String
    let weatherParameters: [WeatherParameterViewModel]
}
