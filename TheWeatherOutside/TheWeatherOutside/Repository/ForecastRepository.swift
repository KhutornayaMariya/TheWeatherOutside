//
//  ForecastRepository.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 04.01.23.
//

import Foundation
import CoreLocation

protocol ForecastRepositoryProtocol: AnyObject {
    func fetchData(completionHandler: @escaping ([MetaInfo]) -> Void)
    func fetchDataForLocation(title: String, completionHandler: @escaping (Bool, [MetaInfo]) -> Void)
    func fetchCachedForecast(for location: String) -> MetaInfo?
}

final class ForecastRepository {
    
    private let forecastApiManager: ForecastApiManagerProtocol
    private let geoCodeApiManager: GeoCodeApiManagerProtocol
    private let dataManager: CoreDataManager
    
    init() {
        forecastApiManager = ForecastApiManager()
        geoCodeApiManager = GeoCodeApiManager()
        dataManager = CoreDataManager.defaultManager
    }
    
    private lazy var locationManager: CLLocationManager = {
        return CLLocationManager()
    }()
    
    private var cachedData: [MetaInfo] {
        dataManager.metaInfo
    }
    
    private func saveData(_ data: ForecastResponse, for location: String) {
        dataManager.addMetaInfo(forecast: data, locationTitle: location)
    }
    
    private func isLocationAuthorized() -> Bool {
        return locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
    
    private func userLocation() -> CLLocationCoordinate2D? {
        guard isLocationAuthorized(),
              let userLocation = locationManager.location else { return nil }
        return userLocation.coordinate
    }
    
    private func fetchLocationTitle(by coordinates: CLLocationCoordinate2D, completionHandler: @escaping (String?) -> Void) {
        geoCodeApiManager.geoCodeRequest(lat: coordinates.latitude, lon: coordinates.longitude) { response in
            guard let location = response else {
                completionHandler(nil)
                return
            }
            completionHandler(location.name())
        }
    }
    
    private func fetchLocationCoordinates (by title: String, completionHandler: @escaping (CLLocationCoordinate2D?, String?) -> Void) {
        geoCodeApiManager.geoCodeRequest(for: title) { response in
            guard let location = response else {
                completionHandler(nil, nil)
                return
            }
            completionHandler(location.coordinates(), location.name())
        }
    }
}

extension ForecastRepository: ForecastRepositoryProtocol {
    
    func fetchData(completionHandler: @escaping ([MetaInfo]) -> Void) {
        guard cachedData.isEmpty,
              let userCoordinates = userLocation()
        else {
            completionHandler(cachedData)
            return
        }
        
        fetchLocationTitle(by: userCoordinates) { result in
            guard let locationTitle = result else {
                completionHandler([])
                return
            }
            
            self.forecastApiManager.forecastRequest(lat: userCoordinates.latitude, lon: userCoordinates.longitude) { response in
                guard let forecast = response else {
                    completionHandler([])
                    return
                }
                self.saveData(forecast, for: locationTitle)
                completionHandler(self.cachedData)
            }
        }
    }
    
    func fetchDataForLocation(title: String, completionHandler: @escaping (Bool, [MetaInfo]) -> Void) {
        fetchLocationCoordinates(by: title) { coordinates, title  in
            guard let coordinates = coordinates,
                  let title = title,
                  !self.dataManager.doesAlreadyExistMetaInfo(with: title)
            else {
                completionHandler(false, self.cachedData) // TODO: add custom error
                return
            }
            
            self.forecastApiManager.forecastRequest(lat: coordinates.latitude, lon: coordinates.longitude) { response in
                guard let forecast = response else {
                    completionHandler(false, self.cachedData)
                    return
                }
                
                self.saveData(forecast, for: title)
                completionHandler(true, self.cachedData)
            }
        }
    }
    
    func fetchCachedForecast(for location: String) -> MetaInfo? {
        return cachedData.first { metaInfo in
            metaInfo.locationTitle == location
        }
    }
}
