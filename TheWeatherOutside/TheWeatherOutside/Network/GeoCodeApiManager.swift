//
//  GeoCodeApiManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import Foundation
import Alamofire

protocol GeoCodeApiManagerProtocol {
    func geoCodeRequest(for string: String , completionHandler: @escaping (AFDataResponse<GeoCodeResponse>) -> Void)
    func geoCodeRequest(lat: Double, lon: Double, completionHandler: @escaping (AFDataResponse<GeoCodeResponse>) -> Void)
}

final class GeoCodeApiManager {
    
    let geocodeApiUrl = "https://geocode-maps.yandex.ru/1.x/"
    let encryptedApiKey: [UInt8] = [97, 57, 54, 99, 100, 55, 55, 101, 45, 54, 56, 48, 100, 45, 52, 48, 48, 55,
                                    45, 57,50, 53, 53, 45, 50, 55, 97, 100, 57, 97, 55, 50, 55, 56, 48, 57]
    
    private func parameters(_ geocode: String) -> [String : Any] {
        let apiKey = Decryptor().getString(from: encryptedApiKey)
        
        return ["geocode": geocode,
                "format": "json",
                "apikey": apiKey]
    }
}

extension GeoCodeApiManager: GeoCodeApiManagerProtocol {
    
    func geoCodeRequest(lat: Double, lon: Double, completionHandler: @escaping (AFDataResponse<GeoCodeResponse>) -> Void) {
        geoCodeRequest(for: String(lat) + "," + String(lon), completionHandler: completionHandler)
    }
    
    func geoCodeRequest(for string: String, completionHandler: @escaping (AFDataResponse<GeoCodeResponse>) -> Void) {
        AF.request(geocodeApiUrl, parameters: parameters(string)).responseDecodable(of: GeoCodeResponse.self) { response in
            completionHandler(response)
        }
    }
}
