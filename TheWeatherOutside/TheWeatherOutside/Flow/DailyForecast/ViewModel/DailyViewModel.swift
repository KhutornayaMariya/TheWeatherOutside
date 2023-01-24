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
        let dayAndNight: [DayAndNight]
    }
    
    let locationTitle: String
    var dailyForecast: [DailyForecastItem]
}

struct DayAndNight {
    let rise: String
    let set: String
    let duration: String
    let imageName: String
}

struct TimeOfDayItem {
    let title: String
    let temperature: String
    let imageName: String
    let weatherParameters: [WeatherParameterViewModel]
}
