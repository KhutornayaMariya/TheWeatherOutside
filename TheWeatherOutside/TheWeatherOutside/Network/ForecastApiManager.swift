//
//  NetworkManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import Foundation
import Alamofire

protocol ForecastApiManagerProtocol {
    func forecastRequest(lat: Double, lon: Double, units: ForecastApiManager.Units)
}

final class ForecastApiManager {
    
    private let dataManager = CoreDataManager()
    
    private let forecastApiUrl = "https://api.openweathermap.org/data/3.0/onecall"
    
    enum Units: String {
        case metric = "metric"
        case standard = "standard"
    }
}

extension ForecastApiManager: ForecastApiManagerProtocol {
    
    func forecastRequest(lat: Double, lon: Double, units: Units) {
        let parameters = parameters(lat: lat, lon: lon, units: units)
        
        AF.request(forecastApiUrl, parameters: parameters).responseDecodable(of: ForecastResponse.self) {response in
            guard let forecast = response.value else { return }
            self.dataManager.addCurrent(forecast.current)
            for dailyForecast in forecast.daily {
                self.dataManager.addDaily(dailyForecast)
            }
            for hourlyForecast in forecast.hourly {
                self.dataManager.addHourly(hourlyForecast)
            }
            self.dataManager.addMetaInfo(forecast.timezone, forecast.lat, forecast.lon)
        }
    }
    
    private func parameters(lat: Double, lon: Double, units: Units) -> [String : Any] {
        return ["lat": lat,
                "lon": lon,
                "units": units.rawValue,
                "exclude": "minutely",
                "appid": "ae28e8927ee1b009a23f38a9634cbe7a"]
    }
}
