//
//  DailyForecastPresenterProtocol.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import Foundation

protocol DailyForecastPresenterProtocol: AnyObject {
    func showData(_ data: MetaInfo)
}
