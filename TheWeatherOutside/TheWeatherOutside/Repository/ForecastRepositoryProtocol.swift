//
//  ForecastRepositoryProtocol.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import Foundation

protocol ForecastRepositoryProtocol: AnyObject {
    func fetchData(completionHandler: @escaping ([MetaInfo]) -> Void)
    func fetchDataForLocation(title: String, completionHandler: @escaping (Bool, [MetaInfo]) -> Void)
    func fetchHourlyForecast(location: String) -> MetaInfo?
}
