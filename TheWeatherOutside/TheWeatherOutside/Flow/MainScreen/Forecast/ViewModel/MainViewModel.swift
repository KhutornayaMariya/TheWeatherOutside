//
//  MainViewModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import Foundation

struct MainViewModel {
    var locationTitle: String
    var currentForecast: CurrentForecastModel
    var hourlySectionTitle: HeaderCellModel
    var hourlyForecast: [HourlyForecastModel]
    var dailySectionTitle: HeaderCellModel
    var dailyForecast: [DailyForecastModel]
}
