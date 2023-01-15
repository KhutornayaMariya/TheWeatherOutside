//
//  HourlyForecastViewControllerProtocol.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import Foundation

protocol HourlyForecastViewControllerProtocol: AnyObject {
    func show(with dataItems: HourViewModel)
}
