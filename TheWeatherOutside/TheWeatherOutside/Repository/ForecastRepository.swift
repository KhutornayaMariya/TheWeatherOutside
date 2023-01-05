//
//  ForecastRepository.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 04.01.23.
//

import Foundation

final class ForecastRepository {
    
    let forecastApiManager: ForecastApiManagerProtocol
    private let dataManager = CoreDataManager.defaultManager
    
    init() {
        forecastApiManager = ForecastApiManager()
    }
    
    private func saveData(_ data: ForecastResponse, for location: String) {
        dataManager.addMetaInfo(forecast: data, locationTitle: location)
    }
}

extension ForecastRepository {
    func fetchDataForLocation(lat: Double, lon: Double, title: String) {
        guard !dataManager.doesAlreadyExistMetaInfo(with: title) else { return }
        
        forecastApiManager.forecastRequest(lat: lat, lon: lon) { response in
            guard let forecast = response.value else {
                return
            }

            self.saveData(forecast, for: title)
        }
    }
}
