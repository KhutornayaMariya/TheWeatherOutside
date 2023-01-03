//
//  GeoCodeApiManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import Foundation
import Alamofire

protocol GeoCodeApiManagerProtocol {
    func geoCodeRequest(for city: String)
}

final class GeoCodeApiManager {
    
    let geocodeApiUrl = "https://geocode-maps.yandex.ru/1.x/"
}

extension GeoCodeApiManager: GeoCodeApiManagerProtocol {
    
    func geoCodeRequest(for city: String) {
        AF.request(geocodeApiUrl, parameters: parameters(city)).responseDecodable(of: GeoCodeResponse.self) {response in
            debugPrint("Response: \(response)")
        }
    }
    
    private func parameters(_ geocode: String) -> [String : Any] {
        return ["geocode": geocode,
                "format": "json",
                "apikey": "a96cd77e-680d-4007-9255-27ad9a727809"]
    }
}
