//
//  NetworkManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import Foundation
import Alamofire

protocol ForecastApiManagerProtocol {
    func forecastRequest(lat: Double, lon: Double, completionHandler: @escaping (ForecastResponse?) -> Void)
}

final class ForecastApiManager {
    private let forecastApiUrl = "https://api.openweathermap.org/data/3.0/onecall"
    private let encryptedApiKey: [UInt8] = [97, 101, 50, 56, 101, 56, 57, 50, 55, 101, 101, 49, 98, 48, 48, 57,
                                            97, 50, 51, 102, 51, 56, 97, 57, 54, 51, 52, 99, 98, 101, 55, 97]
    
    private func parameters(lat: Double, lon: Double) -> [String : Any] {
        let language = Locale.preferredLanguages[0].contains("ru") ? "ru" : "en"
        let apiKey = Decryptor().getString(from: encryptedApiKey)
        
        return ["lat": lat,
                "lon": lon,
                "units": "metric",
                "exclude": "minutely, alerts",
                "appid": apiKey,
                "lang": language]
    }
}

extension ForecastApiManager: ForecastApiManagerProtocol {
    
    func forecastRequest(lat: Double, lon: Double, completionHandler: @escaping (ForecastResponse?) -> Void) {
        let parameters = parameters(lat: lat, lon: lon)
        
        AF.request(forecastApiUrl, parameters: parameters).responseDecodable(of: ForecastResponse.self) { response in
            completionHandler(response.value)
        }
    }
}
