//
//  HourViewModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 13.01.23.
//

import Foundation

struct HourViewModel {
    let locationTitle: String
    let hoursForecast: [HourOverviewModel]
    let diagramData: WeatherDiagramViewModel
}
