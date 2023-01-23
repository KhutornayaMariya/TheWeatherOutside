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
    private let encryptedApiKey: [UInt8] = [57, 56, 97, 48, 54, 99, 57, 51, 100, 56, 97, 49, 53, 101, 97, 57, 102,
                                            53, 49, 56, 52, 100, 99, 101, 57, 51, 97, 50, 99, 53, 56, 55]
    
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
