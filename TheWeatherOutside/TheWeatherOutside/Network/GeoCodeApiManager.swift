//
//  GeoCodeApiManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import Foundation
import Alamofire

protocol GeoCodeApiManagerProtocol {
    func geoCodeRequest(for string: String , completionHandler: @escaping (GeoCodeResponse?) -> Void)
    func geoCodeRequest(lat: Double, lon: Double, completionHandler: @escaping (GeoCodeResponse?) -> Void)
}

final class GeoCodeApiManager {
    
    let geocodeApiUrl = "https://geocode-maps.yandex.ru/1.x/"
    let encryptedApiKey: [UInt8] = [50, 48, 54, 99, 56, 52, 97, 48, 45, 56, 99, 51, 57, 45, 52, 56, 57, 54, 45, 97,
                                    100, 57, 55, 45, 51, 101, 54, 50, 101, 57, 53, 101, 50, 101, 53, 102]
    
    private func parameters(_ geocode: String) -> [String : Any] {
        let apiKey = Decryptor.getString(from: encryptedApiKey)
        
        return ["geocode": geocode,
                "format": "json",
                "apikey": apiKey]
    }
}

extension GeoCodeApiManager: GeoCodeApiManagerProtocol {
    
    func geoCodeRequest(lat: Double, lon: Double, completionHandler: @escaping (GeoCodeResponse?) -> Void) {
        geoCodeRequest(for: String(lon) + "," + String(lat), completionHandler: completionHandler)
    }
    
    func geoCodeRequest(for string: String, completionHandler: @escaping (GeoCodeResponse?) -> Void) {
        AF.request(geocodeApiUrl, parameters: parameters(string)).responseDecodable(of: GeoCodeResponse.self) { response in
            completionHandler(response.value)
        }
    }
}
