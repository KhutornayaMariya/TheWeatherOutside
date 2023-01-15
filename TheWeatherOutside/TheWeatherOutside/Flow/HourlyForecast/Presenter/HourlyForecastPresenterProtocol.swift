//
//  HourlyForecastPresenterProtocol.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import Foundation

protocol HourlyForecastPresenterProtocol: AnyObject {
    func showData(_ data: MetaInfo)
}
